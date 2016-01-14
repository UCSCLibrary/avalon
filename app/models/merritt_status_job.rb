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
    self.merritt_check_status(pid,batchID)
  end

  def merritt_check_status(pid,batchID)
    batch_uri = "https://merritt.cdlib.org/istatus/bid/"+batchID+'/localfull/%22'+pid+'%22'
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
      case job["value"]
      when "COMPLETED"
        mediaObject = MediaObject.find(pid)
        mediaObject.descMetadata.permalink = job['doc']['jobState']['persistentURL']
        mediaObject.save
      when "FAILED"
        Delayed::Worker.logger.warn("Item #{pid} FAILED to archive in Merritt!")
        #TODO do failure thing
      else
        Delayed::Job.enqueue(MerrittStatusJob.new(pid,batchID),run_at: 10.minutes.from_now)
      end
    end
  end


  def error(job, exception)
    #TODO do something (probably a mailer)
  end

end
