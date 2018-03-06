# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#TODO: add .destroy_all to all Models


#TODO: Add default Admin User

# Create Racial Identities
RacialIdentity.find_or_create_by!(name: 'American Indian or Alaska Native')
RacialIdentity.find_or_create_by!(name: 'Asian')
RacialIdentity.find_or_create_by!(name: 'Black or African American')
RacialIdentity.find_or_create_by!(name: 'Hispanic')
RacialIdentity.find_or_create_by!(name: 'Native Hawaiian or Other Pacific Islander')
RacialIdentity.find_or_create_by!(name: 'White')
RacialIdentity.find_or_create_by!(name: 'Other')

# Create FederalAssistances
FederalAssistance.find_or_create_by!(name: 'Food Stamps / SNAP')
FederalAssistance.find_or_create_by!(name: 'Free or Reduced Medical Services')
FederalAssistance.find_or_create_by!(name: 'Free or Reduced Price Lunch')
FederalAssistance.find_or_create_by!(name: 'Head Start')
FederalAssistance.find_or_create_by!(name: 'TANF')
FederalAssistance.find_or_create_by!(name: 'Temporary Emergency Foods or Commodity Foods')
FederalAssistance.find_or_create_by!(name: 'WIC')

#Create GlossaryTerms
#GlossaryTerm.find_or_create_by!(name: '', description: '', source: '', image_remote_origin: '')
gt1  = GlossaryTerm.find_or_create_by!(name: 'bake', description: 'To cook in an oven.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm3.staticflickr.com/2154/2166440316_09000b4f9c_b.jpg')
gt2  = GlossaryTerm.find_or_create_by!(name: 'beat', description: 'To apply fast, constant motions using a wire whisk or fork.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm5.staticflickr.com/4138/4927692876_67a2d7d307_b.jpg')
#TODO: GET THIS TERM IMG?
gt3  = GlossaryTerm.find_or_create_by!(name: 'blend', description: 'To mix two or more ingredients thoroughly.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: '')
gt4  = GlossaryTerm.find_or_create_by!(name: 'boil', description: 'To cook in water that is boiling; bubbles will continually rise and break on the surface.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm4.staticflickr.com/3093/2835194472_40e2ab981a_b.jpg')
gt5  = GlossaryTerm.find_or_create_by!(name: 'chop', description: 'To cut into pieces with a knife or food processor.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm3.staticflickr.com/2827/10772730493_44b7205086_z.jpg')
gt6  = GlossaryTerm.find_or_create_by!(name: 'core', description: 'To remove the core and seeds of a fruit.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm5.staticflickr.com/4047/4319953731_fa8659d820_z.jpg')
gt7  = GlossaryTerm.find_or_create_by!(name: 'dice', description: 'To cut into small cubes.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://static.pexels.com/photos/128391/pexels-photo-128391.jpeg')
gt8  = GlossaryTerm.find_or_create_by!(name: 'drain', description: 'To pour off liquid.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm5.staticflickr.com/4110/5194349527_0e67d83364_z.jpg')
gt9  = GlossaryTerm.find_or_create_by!(name: 'fork-tender', description: 'Describes the doneness of a food when a fork can easily pierce the food.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm1.staticflickr.com/35/73616638_bffa182718_z.jpg?zz&#x3D;1')
gt10 = GlossaryTerm.find_or_create_by!(name: 'knead', description: 'To mix dough by pushing and folding.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm5.staticflickr.com/4098/4886771329_fef31b6582_b.jpg')
gt11 = GlossaryTerm.find_or_create_by!(name: 'mince', description: 'To chop or cut into very small pieces.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm5.staticflickr.com/4113/4967858727_98897310bb_b.jpg')
gt12 = GlossaryTerm.find_or_create_by!(name: 'mix', description: 'To combine two or more ingredients.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm3.staticflickr.com/2106/2072500915_0ce874dc84_b.jpg')
gt13 = GlossaryTerm.find_or_create_by!(name: 'peel', description: 'To remove the outer covering of foods such as oranges or bananas.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://cdn.pixabay.com/photo/2016/11/06/14/27/apples-1803049_960_720.jpg')
gt14 = GlossaryTerm.find_or_create_by!(name: 'rinse', description: 'To douse or drench in clean water as a final stage of washing.', source: 'http://www.dictionary.com/browse/rinse', image_remote_origin: 'https://cdn.pixabay.com/photo/2014/02/23/14/42/washing-vegetables-272963_960_720.jpg')
gt15 = GlossaryTerm.find_or_create_by!(name: 'saute', description: 'To brown or cook in a small amount of fat.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm9.staticflickr.com/8035/7933059720_cc8a529a29_b.jpg')
gt16 = GlossaryTerm.find_or_create_by!(name: 'sift', description: 'To put one or more dry ingredients through a sieve or sifter.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://images.pexels.com/photos/271082/pexels-photo-271082.jpeg?w=1260&h=750&auto=compress&cs=tinysrgb')
gt17 = GlossaryTerm.find_or_create_by!(name: 'simmer', description: 'To cook food over low heat in a liquid just below the boiling point; bubbles will form slowly but never reach the surface.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm8.staticflickr.com/7217/7096587775_6a7de14ae4_b.jpg')
gt18 = GlossaryTerm.find_or_create_by!(name: 'slice', description: 'Cut (something, especially food) into slices.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://cdn.pixabay.com/photo/2017/01/10/19/05/watermelon-1969949_960_720.jpg')
gt19 = GlossaryTerm.find_or_create_by!(name: 'spatula', description: 'An implement with a broad, flat, blunt blade, used for mixing and spreading things, especially in cooking and painting.', source: 'https://en.oxforddictionaries.com/definition/spatula', image_remote_origin: 'https://cdn.pixabay.com/photo/2017/04/04/17/18/spatula-2202239_960_720.jpg')
gt20 = GlossaryTerm.find_or_create_by!(name: 'steam', description: 'http://www.dictionary.com', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm2.staticflickr.com/1056/3172153607_7b1601cd46_b.jpg')
#TODO: GET THIS TERM IMG?
gt21 = GlossaryTerm.find_or_create_by!(name: 'stir', description: 'To mix ingredients with a circular motion until well blended or of uniform consistency.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: '')
gt22 = GlossaryTerm.find_or_create_by!(name: 'stir-fry', description: 'To fry small pieces of food quickly using only a small amount of oil and stirring with a tossing motion.', source: 'Food: A Handbook of Terminology, Purchasing & Preparation. 10th Ed. Alexandria, VA: American Association of Family and Consumer Sciences, 2001', image_remote_origin: 'https://farm5.staticflickr.com/4022/4349516009_546efc8142_b.jpg')
gt23 = GlossaryTerm.find_or_create_by!(name: 'whip/whisk', description: 'To beat food such as cream, eggs or gelatin rapidly to incorporate air and increase volume.', source: 'https://www.macmillandictionary.com/dictionary/american/whip_2', image_remote_origin: 'https://cdn.pixabay.com/photo/2013/12/22/18/48/egg-white-snow-232655_960_720.jpg')

#Create Videos
Video.find_or_create_by!(title: 'Sweet Deceit', description: 'Drinking sugar-sweetened beverages is associated with unwanted weight gain and obesity. Choosing better beverages, like water, is a smart choice for the whole family and for your wallet. Choose Health: Drink Water.', video_id: 'nx5L4Tulv7Q', redirect_url: '/surveys/SV_2shasM4V0EexFQ1/')
Video.find_or_create_by!(title: 'Food eTalk Introduction Tutorial', description: 'This tutorial introduces Food eTalk with a brief overview of the course and demonstrates how to use the lessons.', video_id: 'WuUFJ2dqmq0', redirect_url: '')
Video.find_or_create_by!(title: 'Just in Time - Tips for Planning Menus', description: 'Watch and learn simple ways to keep save money, time, and stress by planning meals.', video_id: 'VVez_v8-LPs', redirect_url: '')
Video.find_or_create_by!(title: 'Just in Time - Tips for Food Safety', description: 'Watch and learn simple ways to keep yourself and your family safe from food borne illness.', video_id: 'G1OUmTRXDIg', redirect_url: '')
Video.find_or_create_by!(title: 'Just in Time - Tips for Buying Dairy', description: 'Watch and learn simple ways to make smart choices in the dairy aisle.', video_id: 'wEIIkAspsqU', redirect_url: '')
Video.find_or_create_by!(title: 'Just in Time - Tips for Buying Bread', description: 'Watch and learn simple ways to make smart choices in the bread aisle.', video_id: 'dDFNktNoN8Y', redirect_url: '')
#TODO: FINISH ADDING VIDEOS
#Video.find_or_create_by!(title: "TITLE", description: "DESC", url: "URL", redirect_url: "REDIRECT")


##################################################################################################
#Add Recipes
##################################################################################################
Ingredient.destroy_all
Recipe.destroy_all
Category.destroy_all
RecipeCategorization.destroy_all

#TODO: delete all uploded images or change CarrierWave to overwrite image


##################################################################################################

# import recipes
Dir.glob(Rails.root + "app/assets/javascripts/json/recipes/*.json") do |file|
  recipe = Recipe.new.from_json(File.read(file), true)
  recipe.save!
end

#TODO: add remaining Recipes as JSON files

##################################################################################################

=begin

#Create Categories & Ingredients - these will be created individually in recipe.json files as

"ingredients_attributes": [
  {"quantity":2,"unit_of_measure":"teaspoon","name":"vegetable oil","note":""},
  {"quantity":1,"unit_of_measure":"whole","name":"large onion","note":"chopped"},
  {"quantity":1,"unit_of_measure":"teaspoon","name":"garlic","note":"minced"}
]

etc...

"categories_attributes": [
  {"name": "Vegetarian Friendly"},
  {"name": "Breakfast"},
  {"name": "Gluten Free"},
  {"name": "Healthy Desserts"},
  {"name": "Kid Friendly"},
  {"name": "Less Than $5 meals"},
  {"name": "Fast and Easy"},
  {"name": "5 Ingredients or Less"}
],

etc...

=end



##################################################################################################
#TODO: add default Blogs
##################################################################################################



