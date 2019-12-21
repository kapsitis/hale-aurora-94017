import re

def getSublines(frameNum,data):
    result = list()
    # offset from the left (0 for the left-side frame, 1 for the right-side frame)
    offsetX = (frameNum-1) % 2
    # offset from the top (how many frames you skip before you reach the needed one)
    offsetY = (frameNum-1) // 2

    yCount = 0
    for line in data.split('\n'): 
        if re.match('^-+$', line):
            #print('Separator encountered')
            yCount += 1
        if yCount == offsetY+1:
            z = re.match('!(.*)!(.*)!',line)
            if z:
                fline = z.groups()[offsetX]
                print('fff={}'.format(fline))
                result.append(fline)
    return result

def main(): 
    # Read file saved by 'bridge-extraction.py'
    with open('plaintext-file.txt', 'r') as file:
        data = file.read()
    
    # visit all frames from 1 to 30
    for i in range(0,30):
        frameNum = i+1
        frameLines = getSublines(frameNum,data)
        text_file = open('{:02d}.txt'.format(frameNum), 'w')
        text_file.write('\n'.join(frameLines))
        text_file.close()

if __name__ == '__main__':
    main()
