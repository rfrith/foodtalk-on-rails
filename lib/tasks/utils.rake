namespace :utils do
  desc "Converts a drupal node export .txt file into a valid JSON file"
  task convert_drupal_recipe_node_to_json: :environment do

    include ActionView::Helpers

    input_dir = "/Users/rfrith/Downloads/recipe-node-exports/*"
    output_dir = Rails.root + "app/assets/javascripts/json/recipes/"

    Dir.glob(input_dir) do |file|

      new_file = ""
      file_header = '{' + "\n" + '  "recipe": {' + "\n"
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
          title = strip_chars("'title'", "title", line)
          file_top_level_attributes << title + "\n"
        end

        if source.nil? && /'recipe_source'/.match(line)
          source = strip_chars("'recipe_source'", "source", line)
          file_top_level_attributes << source + "\n"
        end

        if source_url.nil? && /'url'/.match(line)
          source_url = strip_chars("'url'", "source_url", line)
          file_top_level_attributes << source_url + "\n"
        end

        if str_yield.nil? && /'recipe_yield'/.match(line)
          str_yield = strip_chars("'recipe_yield'", "yield", line)
          file_top_level_attributes << str_yield + "\n"
        end

        if yield_unit.nil? && /'recipe_yield_unit'/.match(line)
          yield_unit = strip_chars("'recipe_yield_unit'", "yield_unit", line)
          file_top_level_attributes << yield_unit + "\n"
        end

        if description.nil? && /'recipe_description'/.match(line)
          description = strip_chars("'recipe_description'", "description", line)
          file_top_level_attributes << strip_tags(description) + "\n"
        end

        if instructions.nil? && /'recipe_instructions'/.match(line)
          instructions = strip_chars("'recipe_instructions'", "instructions", line)
          file_top_level_attributes << instructions + "\n"
        end

        if notes.nil? && /'recipe_notes'/.match(line)
          notes = strip_chars("'recipe_notes'", "notes", line)
          file_top_level_attributes << notes + "\n"
        end

        if preptime.nil? && /'recipe_preptime'/.match(line)
          preptime = strip_chars("'recipe_preptime'", "prep_time", line)
          file_top_level_attributes << preptime + "\n"
        end

        if cooktime.nil? && /'recipe_cooktime'/.match(line)
          cooktime = strip_chars("'recipe_cooktime'", "cooking_time", line)
          file_top_level_attributes << cooktime + "\n"
        end

        if remote_image_url.nil? && /'uri'/.match(line)
          remote_image_url = strip_chars("'uri'", "remote_image_url", line)
          remote_image_url.gsub!("public://recipe-photos/", "https://foodtalk.org/sites/default/files/styles/large/public/recipe-photos/")
          file_top_level_attributes << remote_image_url + "\n"
        end

        #ingredients attributes

        if /            'name'/.match(line)
          name = line.gsub("'", "\"")
          name.gsub!(/\"\"/, "null")
          name.gsub!(/\s=>\s/, ": ")
          name.lstrip!.rstrip!
        end

        if /            'note'/.match(line)
          note = line.gsub("'", "\"")
          note.gsub!(/\"\"/, "null")
          note.gsub!(/\s=>\s/, ": ")
          note.lstrip!.rstrip!
        end

        if /            'quantity'/.match(line)
          quantity = line.gsub("'", "\"")
          quantity.gsub!(/\"\"/, "null")
          quantity.gsub!(/\s=>\s/, ": ")
          quantity.lstrip!.rstrip!
        end

        if /            'unit_key'/.match(line)
          unit_of_measure = line.gsub("'", "\"")
          unit_of_measure.gsub!(/\"\"/, "null")
          unit_of_measure.gsub!(/\s=>\s/, ": ")
          unit_of_measure.gsub!("unit_key", "unit_of_measure")
          unit_of_measure.lstrip!.rstrip!
        end

        if(name && note && quantity && unit_of_measure)
          ingredient = "{#{quantity}#{unit_of_measure}#{name}#{note.chop}}"
          ingredients << "  " + ingredient
          ingredient, name, note, quantity, unit_of_measure = nil
        end

        #TODO: add Category section

        #TODO: add Food Glossary Terms section

        #TODO: add Food Talk Tips section

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

      file_name = title.gsub /\"title\":/, ''

      file_name.lstrip!.rstrip!
      file_name.gsub! "\"", ''
      file_name.gsub! "(", ''
      file_name.gsub! ")", ''
      file_name.gsub! ",", ''
      file_name.gsub! /\s/, '-'
      file_name.gsub! "-", "_"
      file_name.gsub!(/[\x00\/\\:\*\?\"<>\|]/, '_')
      file_name << ".json"
      file_name = file_name.tableize.singularize

      #puts "title: #{title}"
      #puts "file_name: #{file_name}"
      #puts new_file

      open(output_dir+file_name, 'w') do |f|
        f.puts new_file
      end

    end
  end

  def strip_chars(key, replacement, line)
    #puts "key: #{key}"
    #puts "replacement: #{replacement}"
    #puts "line: #{line}"

    value = line.gsub(key, "\"#{replacement.gsub("'", "")}\"")
    value.gsub!(" => '", ": \"")
    value.gsub!(" => \"", ": \"")
    value.gsub!("',", "\",")
    value = "    " + value.lstrip!.rstrip!

    #puts "value: #{value}"

    return value

  end

end