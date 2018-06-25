module Maps

  extend ActiveSupport::Concern

  GA_SNAP_ED_MAPS = [
      {id: 'snap-ed-eligibility-locator', target_url: 'https://w-cookie.github.io/SNAP-Ed-Locator-Web-Tool/index.html', title: "Georgia SNAP-Ed Eligibility Locator", description: "" },
      {id: 'snap-ed-qualified-areas', target_url: 'https://w-cookie.github.io/SNAP-Ed-Site-Lists/index.html#7/32.706/-83.197', title: "Georgia SNAP-Ed Implementation Sites", description: "" },
      {id: 'county-health-offices', target_url: 'https://www.foodtalk.org/maps/HealthDeptOffice.html', title: "County Health Office Locations", description: "" },
      {id: 'uga-extension-offices', target_url: 'https://www.foodtalk.org/maps/Extension_office.html', title: "UGA Extension Offices", description: "" },
      {id: 'dfacs-offices', target_url: 'https://www.foodtalk.org/maps/DFCS_office.html', title: "Division of Family And Children Services Offices", description: "" }
  ]

  def self.find_map(id)
    GA_SNAP_ED_MAPS.each do |map|
      if map[:id] == id
        return map
      end
    end
  end

end