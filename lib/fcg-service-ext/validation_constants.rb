BAD_USERNAMES = %w(user users mail login logout new destroy create edit admin ssl xxx sex bitch bitches admin hoe hoes)
REGEX = {
  :url => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
  :username => /^([a-zA-Z0-9_-]{3,16})$/i,
  :email => /^([\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+\.)*[\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)$/i
}
# email regex from http://fightingforalostcause.net/misc/2006/compare-email-regex.php