import sys
import json 

# Dict of State abbreviations
states = {
        'AK': 'Alaska',
        'AL': 'Alabama',
        'AR': 'Arkansas',
        'AS': 'American Samoa',
        'AZ': 'Arizona',
        'CA': 'California',
        'CO': 'Colorado',
        'CT': 'Connecticut',
        'DC': 'District of Columbia',
        'DE': 'Delaware',
        'FL': 'Florida',
        'GA': 'Georgia',
        'GU': 'Guam',
        'HI': 'Hawaii',
        'IA': 'Iowa',
        'ID': 'Idaho',
        'IL': 'Illinois',
        'IN': 'Indiana',
        'KS': 'Kansas',
        'KY': 'Kentucky',
        'LA': 'Louisiana',
        'MA': 'Massachusetts',
        'MD': 'Maryland',
        'ME': 'Maine',
        'MI': 'Michigan',
        'MN': 'Minnesota',
        'MO': 'Missouri',
        'MP': 'Northern Mariana Islands',
        'MS': 'Mississippi',
        'MT': 'Montana',
        'NA': 'National',
        'NC': 'North Carolina',
        'ND': 'North Dakota',
        'NE': 'Nebraska',
        'NH': 'New Hampshire',
        'NJ': 'New Jersey',
        'NM': 'New Mexico',
        'NV': 'Nevada',
        'NY': 'New York',
        'OH': 'Ohio',
        'OK': 'Oklahoma',
        'OR': 'Oregon',
        'PA': 'Pennsylvania',
        'PR': 'Puerto Rico',
        'RI': 'Rhode Island',
        'SC': 'South Carolina',
        'SD': 'South Dakota',
        'TN': 'Tennessee',
        'TX': 'Texas',
        'UT': 'Utah',
        'VA': 'Virginia',
        'VI': 'Virgin Islands',
        'VT': 'Vermont',
        'WA': 'Washington',
        'WI': 'Wisconsin',
        'WV': 'West Virginia',
        'WY': 'Wyoming'
}

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    # Parse sentiment scores into dict:scores
    scores = {}
    for line in sent_file:
        term, score = line.split('\t')
        scores[term] = int(score)

    """Parse tweet file to calculate sentiment score
       If tweet line not present output error msg
       Else print sentiment score """
    happy = {}
    for tweet in tweet_file:
        temp = json.loads(tweet)    
        sentiment = 0
        if temp.get('text',None) is not None:
            for word in temp.get('text').split():
                sentiment = sentiment + scores.get(word.lower(),0)
        
        # Method 2 to use User's location and use tweet sentiment obtained above
        if temp.get('user',None) is not None and sentiment > 0:
            if temp['user'].get('location',None) is not None \
                and temp['user'].get('location') != 'null':
                location = temp['user'].get('location').split()
                for i in location:
                    for k,v in states.iteritems():
                        if i==v or i==k:
                            if happy.get(k,None) is not None:
                                happy[k] = happy[k] + 1
                            else: 
                                happy[k] = 1              

    for (k,v) in sorted(happy.items(), key=lambda x: x[1], reverse=True):
        print k
        # We need only the top state
        break

if __name__ == '__main__':
    main()
