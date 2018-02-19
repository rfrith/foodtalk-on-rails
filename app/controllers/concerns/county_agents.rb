module CountyAgents

  COUNTIES = {

      "athens-clarke": {
          name: "Athens-Clarke County",
          address1: "2152 W. Broad Street",
          address2: "",
          city: "Athens",
          state: "GA",
          zip: "30606",
          phone: "(706) 613-3640",
          supervising_agent: {name: "Jackie Dallas", email: "jdallas@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0146.jpg"},
          program_assistants: [
              {name: "Shawanda Johnson", email: "snicolej@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0149.jpg"},
              {name: "Melanie Burton", email: "mburton@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/melanie_burton_100.jpg"}
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
          supervising_agent: {name: "Alexis Roberts", email: "Roberts9@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0158.jpg"},
          program_assistants: [
              {name: "Karen Martin", email: "Kmart07@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/web.jpg"},
              {name: "Patti Hall", email: "phall@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0165.jpg"}
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
          supervising_agent: {name: "Gail Kefentse", email: "gkefents@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/gail_kefentse_100.jpg"},
          program_assistants: [
              {name: "Deborah Cannon", email: "dcannon@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/deborah_cannon_100.jpg"}
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
          supervising_agent: {name: "Laura Smith", email: "lauras@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/laura_smith_100.jpg"},
          program_assistants: []
      },

      dekalb: {
          name: "Dekalb County",
          address1: "4380 Memorial Drive",
          address2: "St. 200",
          city: "Decatur",
          state: "GA",
          zip: "30032-1239",
          phone: "(404) 298-4080",
          supervising_agent: {name: "Breeanna Williams", email: "bswilliams@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0184.jpg"},
          program_assistants: [{name: "Alejandra Roman", email: "roman95@uga.edu", photo_url: ""}]
      },

      fulton: {
          name: "Fulton County",
          address1: "1757 Washington Road",
          address2: "Room 112",
          city: "East Point",
          state: "GA",
          zip: "30344-4151",
          phone: "(404) 762-4077",
          supervising_agent: {name: "Amanda Pencek", email: "adh9513@uga.eduedu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0170.jpg"},
          program_assistants: [
              {name: "Deborah Mallory", email: "dymallor@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/deborah_mallory_100.jpg"},
              {name: "Phyllis Cain", email: "sept1986@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0183.jpg"}
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
          supervising_agent: {name: "Jessie Moore", email: "jessmoor@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/jessie_headshot.png"},
          program_assistants: [
              {name: "Becca Pritchett", email: "beccap@uga.edu", photo_url: "https://foodtalk.org/sites/default/files/cimg_0193.jpg"}
          ]
      }
  }


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