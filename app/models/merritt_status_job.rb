# Copyright 2011-2015, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

class MerrittStatusJob < Struct.new(:pid,:batchID)
  def perform
    Delayed::Worker.logger.info("checking status of item: #{pid}")
    self.merritt_check_status(pid,batchID)
  end

  def merritt_check_status(pid,batchID)
    batch_uri = "https://merritt.cdlib.org/istatus/bid/"+batchID+'/localfull/%22'+pid+'%22'
    Delayed::Worker.logger.debug('batch_uri:'+batch_uri)
    uri = URI.parse(batch_uri);
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = JSON.parse(http.request(request).body)
    if response["total_rows"] == 0
      return nil
    end
    response["rows"].each do |job|
       Delayed::Worker.logger.debug('Job id:'+job["id"]+" status: "+job["value"])
      case job["value"]
      when "COMPLETED"
        Delayed::Worker.logger.info("Item #{pid} completed! Updating permalink: #{job['doc']['jobState']['persistentURL']}")
        mediaObject = MediaObject.find(pid)
        mediaObject.permalink = job['doc']['jobState']['persistentURL']
        mediaObject.save
#        Delayed::Worker.logger.debug('ark:'+ark)
      when "FAILED"
        Delayed::Worker.logger.info("Item #{pid} FAILED!!!")
      #do failure thing
      else
        Delayed::Worker.logger.info("Item #{pid} pending. Will check again in 10 minutes.")
        Delayed::Job.enqueue(MerrittStatusJob.new(pid,batchID),run_at: 10.minutes.from_now)
      end
    end
  end


  def error(job, exception)
    #do something
  end

end
