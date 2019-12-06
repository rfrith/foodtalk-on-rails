module CountyAgents

  extend ActiveSupport::Concern

  COUNTIES = {

      "athens-clarke": {
          name: "Athens-Clarke County",
          address1: "2152 W. Broad Street",
          address2: "",
          city: "Athens",
          state: "GA",
          zip: "30606",
          phone: "(706) 613-3640",
          snap_ed_supervisor: {name: "Jackie Dallas", email: "jdallas@uga.edu", photo_url: ""},
          program_assistants: [
              {name: "Melanie Burton", email: "mburton@uga.edu", photo_url: ""},
              {name: "Lina Rivera", email: "lina1@uga.edu", photo_url: ""},
              {name: "Catherine Scott", email: "cls1435@uga.edu", photo_url: ""}
          ]
      },

      bartow: {
          name: "Bartow County",
          address1: "320 West Cherokee Ave",
          address2: "Room 112",
          city: "Cartersville",
          state: "GA",
          zip: "30120-3059",
          phone: "(770) 387-5142",
          snap_ed_supervisor: {name: "Alexis Roberts", email: "Roberts9@uga.edu", photo_url: ""},
          program_assistants: [
              {name: "Karen Martin", email: "Kmart07@uga.edu", photo_url: ""},
              {name: "Patti Hall", email: "phall@uga.edu", photo_url: ""}
          ]
      },

      clayton: {
          name: "Clayton County",
          address1: "1262 Government Circle",
          address2: "Ste 40",
          city: "Jonesboro",
          state: "GA",
          zip: "30236-5905",
          phone: "(770) 473-3945",
          snap_ed_supervisor: {name: "Gail Kefentse", email: "gkefents@uga.edu", photo_url: ""},
          program_assistants: [
              {name: "Deborah Cannon", email: "dcannon@uga.edu", photo_url: ""},
              {name: "Ariane Durden", email: "cdurden1@uga.edu", photo_url: ""}
          ]
      },

      coffee: {
          name: "Coffee County",
          address1: "709 East Ward Street",
          address2: "",
          city: "Douglas",
          state: "GA",
          zip: "31533",
          phone: "(912) 384-1402",
          snap_ed_supervisor: {name: "Laura Smith", email: "lauras@uga.edu", photo_url: ""},
          program_assistants: [
              {name: "Malory Howard", email: "malory.howard@uga.edu", photo_url: ""}
          ]
      },

      dekalb: {
          name: "Dekalb County",
          address1: "4380 Memorial Drive",
          address2: "St. 200",
          city: "Decatur",
          state: "GA",
          zip: "30032-1239",
          phone: "(404) 298-4080",
          snap_ed_supervisor: {name: "Breeanna Williams", email: "bswilliams@uga.edu", photo_url: ""},
          program_assistants: []
      },

      fulton: {
          name: "Fulton County",
          address1: "1757 Washington Road",
          address2: "Room 112",
          city: "East Point",
          state: "GA",
          zip: "30344-4151",
          phone: "(404) 762-4077",
          snap_ed_supervisor: {name: "Amanda Pencek", email: "adh9513@uga.edu", photo_url: ""},
          program_assistants: [
              {name: "Deborah Mallory", email: "dymallor@uga.edu", photo_url: ""},
              {name: "Phyllis Cain", email: "sept1986@uga.edu", photo_url: ""}
          ]
      },

      gilmer: {
          name: "Gilmer County",
          address1: "1123 Progress Rd",
          address2: "Suite A",
          city: "Ellijay",
          state: "GA",
          zip: "30540",
          phone: "(706) 635-4426",
          snap_ed_supervisor: {name: "Jessie Moore", email: "jessmoor@uga.edu", photo_url: ""},
          program_assistants: [
              {name: "Becca Pritchett", email: "beccap@uga.edu", photo_url: ""}
          ]
      },

      lowndes: {
          name: "Lowndes County",
          address1: "2102 East Hill Avenue",
          address2: "",
          city: "Valdosta",
          state: "GA",
          zip: "31601",
          contact: {name: "Lianet Perez", organization: "Family and Consumer Sciences", position: "SNAP Education Educator", phone: "(229) 333-5185",  email: "Lianet.Perez@uga.edu"}
      }
  }

  #TODO: remove me?
  def self.find_agent(name)
    COUNTIES.each do |county|
      if county[:SUPERVISING_AGENT][:name] == name
        return county[:SUPERVISING_AGENT]
      else
        county[:PROGRAM_ASSISTANTS].each do |pa|
          if pa[:name] == name
            return pa
          end
        end
      end
    end
  end

end
