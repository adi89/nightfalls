#**Nightfalls**


A night out has no reason for monotony. I'm not a fan of cycling through the same few venues or bars. Nightfalls was born from the need to find out what's going on in the city that night. You'll find nightlife relevant tweets from the major nightlife-relevant twitter accounts in the city. Find out the scoop on DJs, scenesters, promoters, and general information. Tap into the culture of the city and find out what's on the bleeding edge of relevance.


##Getting Started:
1. bundle
2. create and migrate database
3. make sure you get your own twitter tokens. *applicaton.yml.example* was included so you can make your own *application.yml*
4. Make your own database.yml. I included an example
5. *rake training_set:import_nightlife *(or if you're short on time ...rake training_set:import_nightlife_abridged)
6. *rails server* at command line
7. go to localhost/admin. the default password in activeadmin is *password*
8. Now, we've got records, which will be used as our training set. It's your job to categorize what's nightlife related. The records already come from a twitter account that's pretty nightlife-centric. Go to the Tweets tab, and get categorizing!
9. foreman start at command line

###Under the Hood ###
** Notable Gems used **
- [Kaminari](https://github.com/amatsuda/kaminari): for pagination
- [Sidekiq](https://github.com/mperham/sidekiq): asynchronous workers that summon tweets from lists
- [Clockwork](https://github.com/tomykaira/clockwork) Call the API every X minutes for new tweets
- [OAuth-Twitter](https://github.com/arunagw/omniauth-twitter) Users must log in through twitter if they want to see all the categories
- **[Twitter](https://github.com/sferik/twitter)** it all starts from here.


