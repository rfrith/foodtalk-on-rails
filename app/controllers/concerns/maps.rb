module Maps

  extend ActiveSupport::Concern

  GA_SNAP_ED_MAPS = [
      {id: 'snap-ed-eligibility-locator', thumbnail: '/images/snap-ed-eligibility-locator.png', target_url: 'https://jshannon75.github.io/SNAP-Ed-Locator-Web-Tool/index.html', title: "gis_resources.maps.eligibility_locator", description: "" },
      {id: 'snap-ed-resources', thumbnail: '/images/snap-ed-resources.png', target_url: 'https://comapuga.shinyapps.io/snaped_resources', title: "gis_resources.maps.snap_ed_resources", description: "" },
  ]

  def self.find_map(id)
    GA_SNAP_ED_MAPS.each do |map|
      if map[:id] == id
        return map
      end
    end
  end

end