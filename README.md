# FOODTALK.ORG

Helping Georgians Eat Healthy & Get Moving!
FoodTalk.org has been made especially for Georgians who want FREE ideas on how to keep their families healthy by making nutritious food choices on a budget!

**System dependencies**
* Ruby 2.6.2
* Rails 5.1.7
* Rspec 3.8
* Capistrano 3.11
* nginx 1.14.0
* PostgreSQL 10
* omniauth
* memcached
* ImageMagick
* Wordpress 5
* MariaDB
* Auth0
* Mailchimp
* Qualtrics
* YouTube

**Configuration**

Beyond normal configuration of the above dependencies, these ENV VARS must also be defined:

    SECRET_KEY_BASE
    DB_HOST
    DB_NAME
    DB_USERNAME 
    DB_PASSWORD
    AUTH0_CLIENT_ID
    AUTH0_CLIENT_SECRET
    AUTH0_DOMAIN
    MAILCHIMP_API_KEY
    MAILCHIMP_LIST_IDS
    QUALTRICS_API_KEY
    QUALTRICS_DATA_CENTER
    QUALTRICS_SURVEY_URL_BASE
    USE_TEST_SURVEY
    BLOG_FEED_URL
    YOUTUBE_CHANNEL_ID
    YOUTUBE_API_KEY
    YOUTUBE_DEFAULT_CHANNEL
    API_CACHING_ENABLED


**Database creation/Database initialization**  
Load schema.rb & run db:seed


**Test Suite**  
run bin/rspec


**memcached for content caching**   
https://memcached.org

**Deployment instructions**  
Capistrano is used for deployment: https://capistranorb.com  
usage: `# cap environment deploy` (staging, production)

