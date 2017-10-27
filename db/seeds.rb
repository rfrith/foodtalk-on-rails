# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#TODO: Add default Admin User

# Create Racial Identities
RacialIdentity.find_or_create_by(name: 'American Indian or Alaska Native')
RacialIdentity.find_or_create_by(name: 'Asian')
RacialIdentity.find_or_create_by(name: 'Black or African American')
RacialIdentity.find_or_create_by(name: 'Hispanic')
RacialIdentity.find_or_create_by(name: 'Native Hawaiian or Other Pacific Islander')
RacialIdentity.find_or_create_by(name: 'White')
RacialIdentity.find_or_create_by(name: 'Other')

# Create FederalAssistances
FederalAssistance.find_or_create_by(name: 'Food Stamps / SNAP')
FederalAssistance.find_or_create_by(name: 'Free or Reduced Price Lunch')
FederalAssistance.find_or_create_by(name: 'Head Start')
FederalAssistance.find_or_create_by(name: 'TANF')
FederalAssistance.find_or_create_by(name: 'Temporary Emergency Foods or Commodity Foods')
FederalAssistance.find_or_create_by(name: 'WIC')

#TODO: add default Blogs

#TODO: add default Recipes

#TODO: add default Videos
