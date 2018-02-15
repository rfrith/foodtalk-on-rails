module Maps
  GA_SNAP_ED_MAPS = [
      {id: 'snap-ed-qualified-areas', target_url: 'https://w-cookie.github.io/SNAP-Ed-Site-Lists/index.html#7/32.706/-83.197', title: "Georgia SNAP-Ed Qualified Areas", description: "" },
      {id: 'county-health-offices', target_url: '/maps/HealthDeptOffice.html', title: "County Health Office Locations", description: "" },
      {id: 'community-gardens-and-food-deserts', target_url: '/maps/CommGardens/CommGardens.html', title: "Community Gardens & Food Deserts", description: "" },
      {id: 'snap-enrollment-by-zip-code', target_url: '/maps/Enrollment_map.html', title: "2010 SNAP Enrollment By Zip Code", description: "" },
      {id: 'uga-extension-offices', target_url: '/maps/Extension_office.html', title: "UGA Extension Offices", description: "" },
      {id: 'dfacs-offices', target_url: '/maps/DFCS_office.html', title: "Division of Family And Children Services Offices", description: "" }
  ]

  def self.find_map(id)
    GA_SNAP_ED_MAPS.each do |map|
      if map[:id] == id
        return map
      end
    end
  end

end