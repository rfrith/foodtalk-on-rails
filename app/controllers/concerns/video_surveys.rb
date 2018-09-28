module VideoSurveys

  extend ActiveSupport::Concern

 MAP_VIDEOS_TO_SURVEYS = [
     {
         name: "Sweet Deceit",
         video_id: "nx5L4Tulv7Q",
         survey_id: "SV_4O88nldEpeHIWVL",

         survey_args:
             {
                 origin: "sweet-deceit",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     },

     {
         name: "Better U Beachball Exercises",
         video_id: "KMS-YQ8iYcA",
         survey_id: "SV_6sP9blf829Vh6C1",
         survey_args:
             {
                 origin: "better-u-beach-ball-exercises",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     },

     {
         name: "Using a Better U Resistance Band",
         video_id: "2hCT7VmHtBA",
         survey_id: "SV_6sP9blf829Vh6C1",
         survey_args:
             {
                 origin: "using-a-better-u-resistance-band",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     },

     {
         name: "Better U Chair Exercises",
         video_id: "vp1livRmAG4",
         survey_id: "SV_6sP9blf829Vh6C1",

         survey_args:
             {
                 origin: "better-u-chair-exercises",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }

     },

     {
         name: "Using a Better U Pedometer",
         video_id: "WE-AFXUQuPU",
         survey_id: "SV_6sP9blf829Vh6C1",

         survey_args:
             {
                 origin: "using-a-better-u-pedometer",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     },

     {
         name: "How To Make Tuscan Pasta",
         video_id: "zcD-1YW2424",
         survey_id: "SV_3Xg0Y1rmMkc5UEd",

         survey_args:
             {
                 origin: "how-to-make-tuscan-pasta",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     },

     {
         name: "Dirty Rice and Black Eyed Peas",
         video_id: "RrD4loMsVi4",
         survey_id: "SV_3Xg0Y1rmMkc5UEd",

         survey_args:
             {
                 origin: "how-to-make-dirty-rice-and-black-eyed-peas",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     },

     {
         name: "How To Make Greens with Beans",
         video_id: "cL_4djQ_HiM",
         survey_id: "SV_3Xg0Y1rmMkc5UEd",

         survey_args:
             {
                 origin: "how-to-make-greens-with-beans",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     },

     {
         name: "How to make Pueblo Chili ",
         video_id: "aHph1aQX6IA",
         survey_id: "SV_3Xg0Y1rmMkc5UEd",

         survey_args:
             {
                 origin: "how-to-make-pueblo-chili",
                 uid: true,
                 email: true,
                 redirect: "/videos"
             }
     }

 ]

 def self.find_video_by_name(name)
   MAP_VIDEOS_TO_SURVEYS.each do |entry|
     if entry[:survey_args][:origin] == name
       return entry
     end
   end
   return nil
 end

  def self.find_video_by_id(video_id)
    MAP_VIDEOS_TO_SURVEYS.each do |entry|
      if entry[:video_id] == video_id
        return entry
      end
    end
    return nil
  end

  def self.find_video_by_survey_id(survey_id)
    MAP_VIDEOS_TO_SURVEYS.each do |entry|
      if entry[:survey_id] == survey_id
        return entry
      end
    end
  end

  def self.get_survey_names
    names = []
    MAP_VIDEOS_TO_SURVEYS.each do |entry|
      names << entry[:survey_args][:origin]
    end
    return names
  end

  def self.valid_video_survey?(id)
    return (get_survey_names.include?(id.gsub("video/", "")))
  end

end