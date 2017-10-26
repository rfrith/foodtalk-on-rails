# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#TODO: Add default Admin User

# Create Racial Identities
RacialIdentity.create(name: 'American Indian or Alaska Native')
RacialIdentity.create(name: 'Asian')
RacialIdentity.create(name: 'Black or African American')
RacialIdentity.create(name: 'Hispanic')
RacialIdentity.create(name: 'Native Hawaiian or Other Pacific Islander')
RacialIdentity.create(name: 'White')
RacialIdentity.create(name: 'None of these')

# Create FederalAssistances
FederalAssistance.create(name: 'Food Stamps / SNAP')
FederalAssistance.create(name: 'Free or Reduced Price Lunch')
FederalAssistance.create(name: 'Head Start')
FederalAssistance.create(name: 'TANF')
FederalAssistance.create(name: 'Temporary Emergency Foods or Commodity Foods')
FederalAssistance.create(name: 'WIC')
FederalAssistance.create(name: 'None of the above')
