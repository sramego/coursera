import sys
import json 

def main():
    tweet_file = open(sys.argv[1])
    tags = {}
    for tweet in tweet_file:
        temp = json.loads(tweet)    
        # Hashtags are array of dict inside entities
        if temp.get('entities',None) is not None:
            for i in temp['entities']['hashtags']:
                word = i['text'].lower()
                if tags.get(word, None) is not None:
                    tags[word] = tags[word]+1
                else:
                    tags[word] = 1

    #Get the frequency of the top ten hashtags
    i = 0      
    for (k,v) in sorted(tags.items(), key=lambda x: x[1], reverse=True):
        i = i+1
        print "%s %s" % (k.encode('utf-8'),v)
        if i == 10:
            break

if __name__ == '__main__':
    main()
