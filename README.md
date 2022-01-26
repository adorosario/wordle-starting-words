
# BACKGROUND
This statistical algorithm attempts to find the best opening move in [Wordle](https://www.powerlanguage.co.uk/wordle/). It uses probabilities of various letters and also combines positional prominence (aka: Greens are more valuable than Yellows which are more valuable than Black) 

TL;DR: The best starting word (based on this statistical analysis) is: *SORES*

# TOP 10 BEST OPENING WORDS
```
SORES   0.187053514459894
SANES   0.186393117455467
SALES   0.185092450299554
SONES   0.182480178987563
SERES   0.182270097325452
SATES   0.181677506446841
SOLES   0.181179511831649
SAMES   0.178924867433163
SENES   0.17769676185312
SADES   0.177647169614936
```

# WORST 10 OPENING WORDS
```
ENZYM   0.029164338821716
OXBOW   0.0317138385865398
UNGUM   0.0330904263604456
UPBOW   0.0332958738522421
UNDUG   0.0333626194635183
EWHOW   0.0336354889380409
ABUZZ   0.0343251390063898
ETHYL   0.0345217000083157
UNFIX   0.0346388897625082
UNBOX   0.0351890719564886
```

# METHODOLOGY
1. Based on all the words in the Wordle dictionary (about 13000 words), the algorithm first calculates the *positional probability*. 
    1. e.g. P('A', 'G', 1) - Probability of A being Green in Position 1
2. It then combines that with the *positional prominence*
    1. e.g. GREEN is more value than YELLOW which is more valuable than BLACK
    2. More on how the coefficients for the positional prominence is outlined below

# POSITIONAL PROMINENCE COEFFICIENT CALCULATION
1. How to calculate relative values of G,Y,B
    1. By the amount of Knowledge gain. 
    2. Green means you gained 0.2 (you locked in 1 of 5 tiles)
    3. Yellow means you got a green with 1/4 probability (anything other than the current tile)
    4. Black means you eliminated 1 character out of 26. And eliminated it in 5 positions. 
2. COEEFICIENTS
    1. G = 0.2
    2. Y = 0.2 / 4 = 0.05
    3. B = 5/POW(25,5) = 0.000000512

# HOW TO BUILD
1. First install the dependencies
    1. Amazon: ```sudo yum install perl-JSON```
    2. Ubuntu: ```sudo apt-get install -y libjson-perl```
2. Run the program on your favorite dictionary
    1. BASIC : ```perl run.pl wordle_answers_plus_allowed_guesses.json > scores.tsv 2> /dev/null```
    2. ADVANCED: ```perl run_with_two_lists.pl wordle_answers_plus_allowed_guesses.json wordle_answers_only.json > scores_split_lists_no_repeat_letters.tsv 2> /dev/null```

# WORD LISTS
1. Based on this [sub-reddit](https://www.reddit.com/r/wordle/comments/s4tcw8/a_note_on_wordles_word_list/), here are the two lists used:
    1. [Answers List](https://gist.github.com/a03ef2cba789d8cf00c08f767e0fad7b.git)
    2. [Allowed Guesses](https://gist.github.com/cdcdf777450c5b5301e439061d29694c.git)

# FURTHER READING
1. Wordle uses a subset of the English dictionary. They use two word lists: 
    1. ANSWERS : This is the list of answer words. (Example) 
    2. ALLOWED GUESSES: This is the list of allowed guesses. (Example)
    3. Due to this, a word you think might be a valid English word, might not be allowed. 
2. This is certainly not the only statistical algorithm. Some good ideas are posted in this [sub-Reddit](https://www.reddit.com/r/wordle/comments/s4tcw8/a_note_on_wordles_word_list/)



