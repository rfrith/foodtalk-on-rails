namespace :utils do
  desc "Converts a drupal node export .txt file into a valid JSON file"
  task convert_drupal_recipe_node_to_json: :environment do

    input_dir = "/Users/rfrith/Downloads/recipe-node-exports/*"
    output_dir = Rails.root + "app/assets/javascripts/json/recipes/"

    puts "processing: " + input_dir

    Dir.glob(input_dir) do |file|

      new_file = ""
      file_header = '{' + "\n" + '"  recipe": {' + "\n"
      file_top_level_attributes = ""
      title = nil
      description = nil
      instructions = nil
      notes = nil
      source = nil
      source_url = nil
      remote_image_url = nil
      str_yield = nil
      yield_unit = nil
      preptime = nil
      cooktime = nil
      ingredients_header = "    \"ingredients_attributes\": ["
      ingredients_footer = "    ]"
      file_footer = "  }\n}"

      file = File.readlines(file)


      ingredients = []

      ingredient, name, note, quantity, unit_of_measure = nil
      name_set, note_set, quantity_set, unit_of_measure_set = false


      file.each do |line|
        #top level attributes

        if title.nil? && /'title'/.match(line)
          title = line.gsub("'", "\"")
          title.gsub!(/\s=>\s/, ": ")
          file_top_level_attributes << "    " + title.lstrip.rstrip + "\n"
        end

        if description.nil? && /'recipe_description'/.match(line)
          description = line.gsub("'", "\"")
          description.gsub!(/\s=>\s/, ": ")
          description.gsub!("recipe_description", "description")
          file_top_level_attributes << "    " + description.lstrip.rstrip + "\n"
        end

        if instructions.nil? && /'recipe_instructions'/.match(line)
          instructions = line.gsub("'", "\"")
          instructions.gsub!(/\s=>\s/, ": ")
          instructions.gsub!("recipe_instructions", "instructions")
          file_top_level_attributes << "    " + instructions.lstrip.rstrip + "\n"
        end

        if notes.nil? && /'recipe_notes'/.match(line)
          notes = line.gsub("'", "\"")
          notes.gsub!(/\s=>\s/, ": ")
          notes.gsub!("recipe_notes", "notes")
          file_top_level_attributes << "    " + notes.lstrip.rstrip + "\n"
        end

        if source.nil? && /'recipe_source'/.match(line)
          #puts "------------------\n found source ------------------- \n"
          source = line.gsub("'", "\"")
          source.gsub!(/\s=>\s/, ": ")
          source.gsub!("recipe_source", "source")
          file_top_level_attributes << "    " + source.lstrip.rstrip + "\n"
        end

        if source_url.nil? && /'url'/.match(line)
          source_url = line.gsub("'", "\"")
          source_url.gsub!(/\s=>\s/, ": ")
          source_url.gsub!("url", "source_url")
          file_top_level_attributes << "    " + source_url.lstrip.rstrip + "\n"
        end

        if remote_image_url.nil? && /'uri'/.match(line)
          remote_image_url = line.gsub("'", "\"")
          remote_image_url.gsub!(/\s=>\s/, ": ")
          remote_image_url.gsub!(/\s*uri/, "remote_image_url")
          remote_image_url.gsub!("public://recipe-photos/", "https://foodtalk.org/sites/default/files/styles/large/public/recipe-photos/")
          file_top_level_attributes << "    " + remote_image_url.lstrip.rstrip + "\n"
        end

        if str_yield.nil? && /'recipe_yield'/.match(line)
          str_yield = line.gsub("'", "\"")
          str_yield.gsub!(/\s=>\s/, ": ")
          str_yield.gsub!("recipe_yield", "yield")
          file_top_level_attributes << "    " + str_yield.lstrip.rstrip + "\n"
        end

        if yield_unit.nil? && /'recipe_yield_unit'/.match(line)
          yield_unit = line.gsub("'", "\"")
          yield_unit.gsub!(/\s=>\s/, ": ")
          yield_unit.gsub!("recipe_yield_unit", "yield_unit")
          file_top_level_attributes << "    " + yield_unit.lstrip.rstrip + "\n"
        end

        if preptime.nil? && /'recipe_preptime'/.match(line)
          preptime = line.gsub("'", "\"")
          preptime.gsub!(/\s=>\s/, ": ")
          preptime.gsub!("recipe_preptime", "preptime")
          file_top_level_attributes << "    " + preptime.lstrip.rstrip + "\n"
        end

        if cooktime.nil? && /'recipe_cooktime'/.match(line)
          cooktime = line.gsub("'", "\"")
          cooktime.gsub!(/\s=>\s/, ": ")
          cooktime.gsub!("recipe_cooktime", "cooktime")
          file_top_level_attributes << "    " + cooktime.lstrip.rstrip + "\n"
        end

        #ingredients attributes



        # {"quantity":1,"unit_of_measure":"cup","name":"calcium-fortified orange juice","note":null},

        if /            'name'/.match(line)
          name = line.gsub("'", "\"")
          name.gsub!(/\"\"/, "null")
          name.gsub!(/\s=>\s/, ": ")
          name.lstrip!.rstrip!
          name_set = true
        end

        if /            'note'/.match(line)
          note = line.gsub("'", "\"")
          note.gsub!(/\"\"/, "null")
          note.gsub!(/\s=>\s/, ": ")
          note.lstrip!.rstrip!
          note_set = true
        end

        if /            'quantity'/.match(line)
          quantity = line.gsub("'", "\"")
          quantity.gsub!(/\"\"/, "null")
          quantity.gsub!(/\s=>\s/, ": ")
          quantity.lstrip!.rstrip!
          quantity_set = true
        end

        if /            'unit_key'/.match(line)
          unit_of_measure = line.gsub("'", "\"")
          unit_of_measure.gsub!(/\"\"/, "null")
          unit_of_measure.gsub!(/\s=>\s/, ": ")
          unit_of_measure.gsub!("unit_key", "unit_of_measure")
          unit_of_measure.lstrip!.rstrip!
          unit_of_measure_set = true
        end

        if(name && note && quantity && unit_of_measure)
          ingredient = "{#{quantity}#{unit_of_measure}#{name}#{note.chop}}"
          ingredients << "  " + ingredient
          ingredient, name, note, quantity, unit_of_measure = nil
        end

        #TODO: add Category section

        #TODO: add Food Glossary Terms section

        #TODO: add Food Talk Tips section


        #glossary terms attributes
      end

      #generate new file contents
      new_file = file_header + file_top_level_attributes + ingredients_header + "\n"
      ingredients.each_with_index do |ingredient, index|
        new_file << "    " + ingredient
        if (index < (ingredients.size - 1))
          new_file << ","
        end
        new_file <<  "\n"
      end
      new_file << ingredients_footer
      new_file <<  "\n"
      new_file << file_footer

      #TODO: create output file(s)
      puts "new_file: \n" + new_file
    end
  end

end
