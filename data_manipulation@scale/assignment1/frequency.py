import sys
import json 

def main():
    tweet_file = open(sys.argv[1])
    words = {}
    for tweet in tweet_file:
        temp = json.loads(tweet)    
        if temp.get('text',None) is not None:
            for word in temp.get('text').split():
                w = word.lower()
                if words.get(w,None) is not None:
                    words[w] = words[w] + 1
                else:
                    words[w] = 1
    # Find total frequency of all words
    total = 0 
    for key in words.keys():
        total = total + words[key]   
    for key in words.keys():
        print "%s %s" % (key.encode('utf-8'),words[key]/float(total))
         
if __name__ == '__main__':
    main()
