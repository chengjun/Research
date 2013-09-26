# R-scripts
# Practising to parse semi-regular text
# http://wiekvoet.blogspot.hk/2013/09/guns-are-cool.html

r1 <- readLines(textConnection('
                               Number 1: 1/1/13, Julian Sims, 4 injured, McKeesport, PA
                               Number 2: 1/1/13, Unknown, 1 dead 3 injured, Hawthorne, CA
                               Number 3: 1/1/13, Desmen Noble, Damian Bell, 1 dead 4 injured, Lorain, OH
                               Number 4: 1/5/13, Sonny Archuleta, 4 dead, Aurora, CO
                               Number 5: 1/7/13, Sandra Palmer, 2 dead 2 injured, Greensboro, NC
                               Number 6: 1/7/13, Herbert Bland Jr., 23, 3 dead 1 injured, Dinwiddie, VA
                               Number 7: 1/7/13, Cedric and James Poore (brothers), 4 dead, Tulsa, OK
                               Number 8: 1/11/13, Unknown, 4 dead, Sacramento, CA
                               Number 9: 1/19/13, Nehemiah Griego, 5 dead, Albuquerque, NM
                               Number 10: 1/21/13, Unknown, 4 injured, Brentwood, CA
                               Number 11: 1/25/13, Unknown, 1 dead 4 injured, St. Louis, MO
                               Number 12: 1/26/13, Unknown, 5 injured, Washington DC
                               Number 13: 1/27/13, Wilbert Thibodeaux, 1 dead 3 injured, Charenton, LA
                               Number 14: 1/30/13, Douglas Harmon, 3 dead 1 injured, Phoenix, AZ
                               Number 15: 2/1/13, Unknown, 1 dead 3 injured, Oakland, CA
                               Number 16: 2/2/13, Sundra Payne, 5 injured, Memphis, TN
                               Number 17: 2/3/13, Kong Meng Vue, Ryan Cha, Ken Cha, 1 dead 3 injured, Olivehurst, CA
                               Number 18: 2/3/13, Christopher Dorner, 5 dead 4 injured, Began in Riverside, CA
                               Number 19: 2/3/13, Jackie Spears & Kelcie Stewart, 2 dead 2 injured, Memphis, TN
                               Number 20: 2/6/13, Mayra Perez, 3 dead 1 injured, Denver, CO
                               Number 21: 2/7/13, Unknown, 4 injured, Chicago, IL
                               Number 22: 2/9/13, Malcolm Hall, Brandon Brown, Deron Bridgewater, 4 injured, New Orleans, LA
                               Number 23: 2/11/13, Nhan Lap Tran, 1 dead 4 injured, Oakdale, MN
                               Number 24: 2/11/13, Unknown, 1 dead 4 injured, Vallejo, CA
                               Number 25: 2/11/13, Thomas Matusiewicz, 3 dead 2 injured, Wilmington, DE
                               Number 26: 2/12/13, Two suspects, David Fresques in custody and Davis Fotu at large, 3 dead 1 injured, Suburban Salt Lake City(Midvale), UT
                               Number 27: 2/13/13, Joseph Matteson, 2 dead 2 injured, Red Springs, NC
                               Number 28: 2/16/13, Unknown, 1 dead 3 injured, Winston-Salem, NC
                               Number 29: 2/19/13, Ali Sayed, 4 dead 3 injured, Tustin, CA
                               Number 30: 2/21/13, Carlos Zuniga, 2 dead 2 injured, Miami, FL
                               Number 31: 2/21/13, Mark Hopkins, 1 dead 3 injured, Tulsa, OK
                               Number 32: 2/22/13, Unknown, 4 injured, Grand Rapids, MI
                               Number 33: 2/23/13, Unknown, 4 injured, Lancaster, CA
                               Number 34: 2/23/13, Unknown, 4 injured, Oakland, CA
                               Number 35: 2/24/13, Unknown, 8 injured, Macon, GA
                               Number 36: 3/2/13, Unknown, 1 dead 3 injured, Shreveport, LA
                               Number 37: 3/3/13, Unknown, 6 injured, Houston, TX
                               Number 38: 3/3/13, Unknown, 1 dead 3 injured, Moultrie, GA
                               Number 39: 3/4/13, Unknown, 4 injured, Saginaw, MI
                               Number 40: 3/4/13, Unknown, 1 dead 3 injured, Los Banos, CA
                               Number 41: 3/5/13, Unknown, 1 dead 3 injured, Indianapolis, IN
                               Number 42: 3/5/13, Unknown, 4 injured, Fuquay-Varina, NC
                               Number 43: 3/7/13, Joshua Hurst, 2 dead 2 injured, Jackson, MS
                               Number 44: 3/8/13, Unknown, 1 dead 3 injured, Buffalo, NY
                               Number 45: 3/10/13, Taleb Salameh, 3 dead 1 injured, North Liberty, IA
                               Number 46: 3/11/13, Taleb Hussein Yousef Salameh, 1 dead 3 injured, Iowa City, IA
                               Number 47: 3/11/13, Andrew Davon Allen and Craig Willson, 13 injured, Washington, DC
                               Number 48: 3/13/13, Unknown, 2 dead 2 injured, San Diego, CA
                               Number 49: 3/13/13, Kurt Myers, 5 dead 2 injured, Herkimer, NY
                               Number 50: 3/14/13, Unknown, 4 injured, Modesto, CA
                               Number 51: 3/15/13, Angelica Vazquez, 4 dead, Mesquite, TX
                               Number 52: 3/16/13, Unknown, 7 injured, Galt, CA
                               Number 53: 3/17/13, Unknown, 5 injured, Belle Glade, FL
                               Number 54: 3/17/13, Unknown, 2 dead 4 injured, Stockton, CA
                               Number 55: 3/20/13, Brandon Menefee, 3 dead 1 injured, Jefferson County, AL
                               Number 56: 3/21/13, Unknown, 7 injured, Chicago, IL
                               Number 57: 3/21/13, Unknown, 1 dead 4 injured, Kansas City, MO
                               Number 58: 3/22/13, Unknown, 1 dead 3 injured, New York, NY
                               Number 59: 3/26/13, Unknown, 4 injured, St. Petersberg, FL
                               Number 60: 3/31/13, Unknown, 2 dead 3 injured, Merced County, CA
                               Number 61: 3/31/13, Unknown, 3 dead 1 injured, Auburn, WA
                               Number 62: 4/2/13, Unknown, 4 dead 1 injured, San Juan, Puerto Rico
                               Number 63: 4/6/13, Unknown, 1 dead 4 injured, Greenwood, SC
                               Number 64: 4/6/13, Unknown spree shooter, 4 injured, Philadelphia, PA
                               Number 65: 4/7/13, Unknown, 1 dead 3 injured, Long Beach, CA
                               Number 66: 4/7/13, 1 in custody, name withheld, 1 dead 3 injured, Manhatten, Kansas
                               Number 67: 4/9/13, Unknown, 1 dead 3 injured, Philadelphia, PA
                               Number 68: 4/10/13, Unknown, 4 injured, Vallejo, CA
                               Number 69: 4/13/13, Trenton Ore, Joven Covington, 5 injured, Norfolk, VA
                               Number 70: 4/13/13, Unknown, 4 injured, Merced, CA
                               Number 71: 4/14/13, Unknown, 1 dead 4 injured, Lexington, KY
                               Number 72: 4/14/13, Unknown, 2 dead 4 injured, Phoenix, AZ
                               Number 73: 4/18/13, Unknown, 4 dead, Akron, OH
                               Number 74: 4/20/13, Unknown, 2 dead 2 injured, Modesto, CA
                               Number 75: 4/20/13, Christine Squire, 2 dead 2 injured, Richmond, VA
                               Number 76: 4/21/13, Unknown, 5 dead 2 injured, Federal Way, WA
                               Number 77: 4/22/13, Davante Robertson, Charlie A. Gumms, Frankie Hookman, Jr and Lashawn Davis, 5 injured, Havey, Louisiana
                               Number 78: 4/22/13, Unknown, 4 injured, Englewood, Illinois
                               Number 79: 4/24/13, Rick Odell Smith, 6 dead 1 injured, Manchester, IL
                               Number 80: 4/25/13, Sean M. Woodings, 4 injured, Oberlin, Ohio
                               Number 81: 4/27/13, Unknown, 1 dead 4 injured, Williston, FL
                               Number 82: 4/28/13, Unknown, 5 injured, Charlotte, NC
                               Number 83: 4/28/13, Neville Lynch, Mark Rose, 4 injured, Lauderdale Lakes, FL
                               Number 84: 4/28/13, Unknown, 2 dead 2 injured, Jackson, Tennessee
                               Number 85: 4/28/13, Unknown drive-by, 1 dead 3 injured, Chester, PA
                               Number 86: 5/2/13, Unknown, 5 injured, Newark, NJ
                               Number 87: 5/4/13, Unknown drive-by, 4 dead 6 injured, Aguas Buenas, PR
                               Number 88: 5/4/13, Krystal Olymica David, 4 injured, Smithfield, NC
                               Number 89: 5/5/13, Unknown, 1 dead 3 injured, Oakland, CA
                               Number 90: 5/5/13, Unknown drive-by, 6 injured, E. Palo Alto, CA
                               Number 91: 5/6/13, Two boys, 10, 11, 4 injured, Ocean Township, NJ
                               Number 92: 5/6/13, Unknown, 4 injured, Johnstown, PA
                               Number 93: 5/8/13, Ralph Robert Warren III, 4 dead, Hendersonville, NC
                               Number 94: 5/10/13, Unknown, 3 dead 1 injured, Harbor Gateway (Los Angeles), CA
                               Number 95: 5/11/13, Unknown, 4 injured, East Germantown, PA
                               Number 96: 5/11/13, Samuel E. Sallee, 4 dead, Waynesville, IN
                               Number 97: 5/12/13, Unknown, 5 injured, Newark, NJ
                               Number 98: 5/12/13, Unknown, 4 injured, Hollister, CA
                               Number 99: 5/12/13, Unknown, 19 injured, New Orleans, LA
                               Number 100: 5/12/13, Unknown, 4 injured, Apache Junction, AZ
                               Number 101: 5/12/13, Unknown, 4 injured, Jersey City, NJ
                               Number 102: 5/13/13, Unknown, 5 injured, Winton Hills, OH
                               Number 103: 5/15/13, Arrest made 5/21, 1 dead 4 injured, Detroit, MI
                               Number 104: 5/15/13, Jeremiah Bean, 5 dead, Fernley, NV
                               Number 105: 5/16/13, Unknown, 4 injured, Philladelphia, PA
                               Number 106: 5/18/13, Unknown, 3 dead 3 injured, Las Piedras, PR
                               Number 107: 5/19/13, Unknown, 4 injured, Detroit, MI
                               Number 108: 5/19/13, Codarrell Lee Yates, 4 injured, Lunenburg, VA
                               Number 109: 5/19/13, Unknown, 2 dead 2 injured, South Memphis, TN
                               Number 110: 5/20/13, Unknown, 4 injured, Chicago, IL
                               Number 111: 5/21/13, Unknown, 4 injured, Madison County, AL
                               Number 112: 5/23/13, Jason Brian Holt, 2 dead 2 injured, Knoxville, TN
                               Number 113: 5/23/13, Evellis T. McGee and Karon D. Thomas, 1 dead 3 injured, Saginaw, MI
                               Number 114: 5/24/13, Julio Jesus Romero, 2 dead 2 injured, Bakersfield, CA
                               Number 115: 5/25/13, Antonio King Green, 1 dead 3 injured, Flint, MI
                               Number 116: 5/25/13, Ryan Taybron, 15, and Eric Nixon, 17, 1 dead 4 injured, Hampton, VA
                               Number 117: 5/26/13, Esteban J. Smith, 3 dead 5 injured, Eden, TX & Jacksonville, NC
                               Number 118: 5/28/13, Unknown, 1 dead 3 injured, Memphis, TN
                               Number 119: 5/28/13, Unknown, 5 dead, Sells, AZ
                               Number 120: 5/29/13, Unknown, 4 injured, Chicago (Bronzeville), IL
                               Number 121: 5/31/13, Unknown, 4 injured, Atlanta, GA
                               Number 122: 6/1/13, Unknown, 2 dead 2 injured, Vallejo, CA
                               Number 123: 6/1/13, Unknown, 4 injured, Milwaukee, WI
                               Number 124: 6/2/13, Unknown, 4 injured, Indianapolis, IN
                               Number 125: 6/2/13, Unknown, 4 injured, Virginia Beach, VA
                               Number 126: 6/2/13, Unknown, 5 injured, Roanoke, VA
                               Number 127: 6/2/13, Xavier Edmondson and Lewis Antonio, 7 injured, LaGrange, GA
                               Number 128: 6/3/13, Manuel Mata III, 2 dead 2 injured, Las Vegas, NV
                               Number 129: 6/4/13, Johnny Simpson, 2 dead 2 injured, Shoreview, MN
                               Number 130: 6/5/13, St. Charles resident, 10 injured, Elburn, IL
                               Number 131: 6/7/13, John Zawahri, 5 dead 5 injured, Santa Monica, CA
                               Number 132: 6/9/13, Unknown, 4 injured, York City, PA
                               Number 133: 6/10/13, Unknown, 1 dead 5 injured, Chicago, IL
                               Number 134: 6/10/13, Davonta Coleman, 6 injured, St. Louis, MO
                               Number 135: 6/11/13, David Andrus, 4 dead, Darien, IL
                               Number 136: 6/12/13, Ahmed Dirir, 4 dead, St. Louis, MO
                               Number 137: 6/14/13, Unknown, 4 injured, High Point, NC
                               Number 138: 6/15/13, Earnest Woodley, 4 injured, Nashville, TN
                               Number 139: 6/15/13, Unknown, 1 dead 3 injured, Houston, TX
                               Number 140: 6/16/13, Unknown, 1 dead 3 injured, Chicago, IL
                               Number 141: 6/18/13, Unknown, 1 dead 3 injured, Berkeley, MO
                               Number 142: 6/19/13, Gary W. Stewart Jr., 3 dead 1 injured, Louisville, KY
                               Number 143: 6/21/13, Darren Lamont Roberts and Kyle Edward Thornton, 6 injured, Norfolk, VA
                               Number 144: 6/21/13, Unknown, 1 dead 3 injured, (Kelvyn Park) Chicago, IL
                               Number 145: 6/22/13, Unknown, 1 dead 4 injured, Baltimore, MD
                               Number 146: 6/22/13, Kamal “Rico” Edge, 1 dead 4 injured, Paterson, NJ
                               Number 147: 6/22/13, Unknown, 4 injured, Providence, RI
                               Number 148: 6/22/13, Lakim Anthony Faust, 5 injured, Greenville, NC
                               Number 149: 6/23/13, Unknown, 4 injured, Gentilly, LA
                               Number 150: 6/23/13, Unknown, 1 dead 3 injured, Chattanooga, TN
                               Number 151: 6/23/13, Unknown, 1 dead 4 injured, Virginia Beach, VA
                               Number 152: 6/23/13, Unknown, 1 dead 8 injured, Kansas City, MO
                               Number 153: 6/23/13, Elijah Rodgers, 1 dead 3 injured, Sacramento, CA
                               Number 154: 6/24/13, Unknown, 1 dead 3 injured, Kansas City, MO
                               Number 155: 6/25/13, Unknown, 1 dead 4 injured, Chicago, IL
                               Number 156: 6/27/13, Manuel Talamantez, Christina Martinez, 2 dead 2 injured, Three Rivers, CA
                               Number 157: 6/27/13, Tierra Fallin, 1 dead 3 injured, Baltimore, MD
                               Number 158: 6/28/13, Unknown, 6 injured, Chicago, IL
                               Number 159: 6/29/13, Ronald Reid, Barry Stinson, 3 dead 1 injured, North Charleston, SC
                               Number 160: 6/29/13, Unknown, 4 injured, Aurora, CO
                               Number 161: 6/30/13, Unknown, 9 injured, Brooklyn, NY
                               Number 162: 7/1/13, Amos Wells, 4 dead, Fort Worth, TX
                               Number 163: 7/2/13, Unknown, 1 dead 3 injured, Montgomery, AL
                               Number 164: 7/3/13, Unknown, 1 dead 3 injured, Calais, Maine
                               Number 165: 7/4/13, Robert Marion Naylor, 1 dead 6 injured, Pontiac, MI
                               Number 166: 7/4/13, Unknown, 4 injured, Woodlawn, IL
                               Number 167: 7/5/13, Unknown, 1 dead 3 injured, Macon, GA
                               Number 168: 7/6/13, Brandon Reese, 1 dead 3 injured, Brooklyn, NY
                               Number 169: 7/6/13, Unknown, 1 dead 7 injured, Chicago, IL
                               Number 170: 7/6/13, Chauncy Laray Mitchell, 4 injured, Florence, AL
                               Number 171: 7/6/13, Unknown, 1 dead 3 injured, Los Angeles, CA
                               Number 172: 7/7/13, Unknown, 1 dead 4 injured, Stockton, CA
                               Number 173: 7/7/13, Unknown, 1 dead 3 injured, Pompano Beach, FL
                               Number 174: 7/7/13, Unknown, 4 injured, Meridian, Miss.
                               Number 175: 7/7/13, Unknown, 1 dead 5 injured, Chicago, IL
                               Number 176: 7/9/13, Lamont Jones, 4 injured, Balimore, MD
                               Number 177: 7/9/13, Unknown, 2 dead 2 injured, Rockford, IL
                               Number 178: 7/10/13, Konrad Schafer, 15, and David Damus, 20, 2 dead 12 injured, Kissimmee, FL
                               Number 179: 7/11/13, Unknown, 1 dead 3 injured, Charlotte, NC
                               Number 180: 7/12/13, Unknown, 2 dead 2 injured, Greensburg, KY
                               Number 181: 7/12/13, Unknown, 1 dead 3 injured, San Francicsco, CA
                               Number 182: 7/12/13, Unknown, 1 dead 4 injured, Hamilton Township, NJ
                               Number 183: 7/13/13, Unknown, 4 injured, Washington DC
                               Number 184: 7/13/13, Unknown, 1 dead 3 injured, Oklahoma City, OK
                               Number 185: 7/13/13, Unknown, 5 dead 1 injured, New Orleans, LA
                               Number 186: 7/14/13, Unknown, 1 dead 4 injured, Wichita, KS
                               Number 187: 7/14/13, Suspect in custody., 5 injured, Kentwood, MI
                               Number 188: 7/14/13, Phillip Brierly Jr., 2 dead 2 injured, Lexington, SC
                               Number 189: 7/17/13, Unknown, 3 dead 1 injured, Oakland, CA
                               Number 190: 7/19/13, Unknown, 4 injured, Madera, CA
                               Number 191: 7/19/13, Unknown, 4 injured, Hartford, CT
                               Number 192: 7/20/13, Devin Spann, 5 injured, Campbell, OH
                               Number 193: 7/21/13, Unknown, 4 injured, Brooklyn (Crown Heights), NY
                               Number 194: 7/21/13, Unknown, 5 injured, Brooklyn (Bushwick), NY
                               Number 195: 7/21/13, Unknown, 2 dead 2 injured, Fort Pierce, FL
                               Number 196: 7/21/13, Terrence Lynom, Angelo Clark, 1 dead 3 injured, Chicago, IL
                               Number 197: 7/24/13, Unknown, 4 injured, Topeka, KS
                               Number 198: 7/25/13, Unknown, 4 injured, Inkster, MI
                               Number 199: 7/26/13, Sidney A. Muller, 4 dead, Clarksburg, WV
                               Number 200: 7/26/13, Unknown, 7 dead, Hialea, FL
                               Number 201: 7/27/13, Unknown, 1 dead 3 injured, Farmington, NM
                               Number 202: 7/28/13, Unknown, 4 injured, Granger, WA
                               Number 203: 7/28/13, Unknown, 1 dead 3 injured, Irvington, NJ
                               Number 204: 7/28/13, Unknown, 5 injured, Dallas, TX
                               Number 205: 7/30/13, Parrish Chee, 4 injured, Lea County (Hobbs), NM
                               Number 206: 8/2/13, Tristan Crayton, 4 injured, Broad Ripple, IN
                               Number 207: 8/2/13, Unknown, 4 dead, Whitesburg, KY
                               Number 208: 8/2/13, Unknown, 2 dead 3 injured, Newark, NJ
                               Number 209: 8/3/13, Unknown, 5 injured, Detriot, MI
                               Number 210: 8/4/13, Giovanni Pacheco, 3 dead 4 injured, Salinas, CA
                               Number 211: 8/4/13, Unknown, 1 dead 3 injured, Kansas City, Mo
                               Number 212: 8/5/13, Rockne Newell, 3 dead 4 injured, Ross Township, PA
                               Number 213: 8/5/13, Suspect known., 4 injured, Montclair, NJ
                               Number 214: 8/7/13, Erbie Bowser, 4 dead 4 injured, Dallas, TX
                               Number 215: 8/11/13, Nikko Jenkins, 4 dead, Omaha, NE
                               Number 216: 8/11/13, Unknown, 1 dead 3 injured, Flatbush, NY
                               Number 217: 8/11/13, Unknown, 1 dead 4 injured, Portsmouth, VA
                               Number 218: 8/11/13, Unknown, 4 injured, Wilmington, Del.
                               Number 219: 8/11/13, Unknown, 2 dead 2 injured, St. Louis, MO
                               Number 220: 8/12/13, Unknown, 4 injured, Cincinnati, OH
                               Number 221: 8/16/13, Unknown, 4 injured, Kingsessing, PA
                               Number 222: 8/17/13, Demetrius Ward, 4 injured, Oakland, CA
                               Number 223: 8/18/13, Unknown, 1 dead 3 injured, Chicago, IL
                               Number 224: 8/18/13, Darryl Sain, 4 injured, St. Louis, MO
                               Number 225: 8/18/13, Dontrel Shyhee Blakeney, 17, 1 dead 4 injured, Chesterfield County, SC
                               Number 226: 8/18/13, Unknown, 1 dead 3 injured, Rochester, NY
                               Number 227: 8/18/13, Unknown, 4 injured, Port Norris, NJ
                               Number 228: 8/18/13, Unknown, 4 injured, Toledo, OH
                               Number 229: 8/19/13, Suspects in custody., 1 dead 4 injured, Chicago, IL
                               Number 230: 8/20/13, Unknown, 4 injured, Vanceboro, NC
                               Number 231: 8/20/13, Daniel Livingston Green, 4 dead, Oklahoma City, OK
                               Number 232: 8/20/13, Melville Mason, 2 dead 2 injured, Baltimore, MD
                               Number 233: 8/22/13, Jim Edwards, 2 dead 2 injured, Shaler, PA
                               Number 234: 8/23/13, Unknown, 1 dead 6 injured, Baltimore, MD
                               Number 235: 8/24/13, Unknown, 4 injured, Indianapolis, IN
                               Number 236: 8/25/13, Hubert Allen, Jr., 3 dead 2 injured, Lake Butler, FL
                               Number 237: 8/25/13, Unknown, 2 dead 2 injured, Minneapolis, MN
                               Number 238: 8/25/13, Unknown, 1 dead 4 injured, Dillon County, SC
                               Number 239: 8/25/13, Unknown, 4 injured, Oakland, CA
                               Number 240: 8/28/13, Devonere Simmonds, 3 dead 2 injured, Columbus, OH
                               Number 241: 9/5/13, Unknown, 4 injured, Charlotte, NC
                               Number 242: 9/7/13, Unknown, 2 dead 4 injured, Gary, IN
                               Number 243: 9/7/13, Darnell Hollings, 1 dead 3 injured, St. Louis, MO
                               Number 244: 9/10/13, Roderick Rodgers, 1 dead 4 injured, Bridgeport, CT
                               Number 245: 9/11/13, Unknown, 1 dead 3 injured, Washington DC
                               Number 246: 9/11/13, Unknown, 4 injured, New York, NY
                               Number 247: 9/12/13, Jacob Bennett, Brittany Moser, 4 dead, Renegade Mountain, TN
                               Number 248: 9/13/13, Unknown, 4 injured, Centreville, IL
                               Number 249: 9/14/13, Earl Spencer Boyce
                               Number 250: 9/15/13, Unknown, 6 injured, Yakima, WA
                               Number 251: 9/15/13, Unknown, 5 injured, Colorado Springs, CO
                               Number 252: 9/15/13, Unknown, 7 injured, Fresno, CA
                               Number 253: 9/15/13, Unknown, 2 dead 2 injured, Bakersfield, CA
                               Number 254: 9/15/13, Robert E. Bell, 3 dead 1 injured, Snellville, GA
                               Number 255: 9/15/13, Unknown, 4 injured, Wilmington, DE
                               Number 256: 9/16/13, Aaron Alexis, 13 dead 8 injured, Washington DC
                               Number 257: 9/17/13, Unknown, 1 dead 4 injured, Stockton, CA
                               Number 258: 9/17/13, Unknown, 4 injured, Lansing, MI
                               Number 259: 9/17/13, Unknown, 4 injured, Las Vegas, NV
                               Number 260: 9/17/13, Unknown, 4 dead, West Broward, FL
                               Number 261: 9/18/13, Unknown, 1 dead 4 injured, Whitehaven, TN
                               Number 262: 9/18/13, Unknown, 5 injured, Kissimmee, FL
                               Number 263: 9/18/13, Unknown, 1 dead 4 injured, Bakersfield, CA
                               Number 264: 9/19/13, Unknown, 13 injured, Chicago, IL
                               '),)

r1[r1=='Number 249: 9/14/13, Earl Spencer Boyce'] <-
  'Number 249: 9/14/13, Earl Spencer Boyce, 4 injured, Marion, NC'
#empty first & last line
r2 <- gsub('Number ','',r1[r1!=''])
mydf <- data.frame(Number=as.numeric(gsub(':.*$','',r2)))
r3 <- gsub('^.*: ','',r2)
mydf$Date <- as.Date(gsub('/13, .*$','/13',r3),format='%m/%d/%y')
r4 <- gsub('^.*/13, ', '',r3)
r4 <- gsub('dead ','dead, ',r4)
r4 <- gsub('injured ','injured, ',r4)
r4 <- gsub('Washington DC','Washington, DC',r4)
r5 <- strsplit(r4,',')
r4[sapply(r5,length)>5]
grep('TX & ',r1,value=TRUE)
#mydf$nfield <- sapply(r5,length)

mydf$state <- unlist(sapply(r5,function(x) 
  gsub(' ','',x[length(x)])))
mydf$dead <- sapply(r5,function(x) 
  as.numeric(gsub('dead','',grep('dead',x,value=TRUE)[1])))
mydf$injured <- sapply(r5,function(x) 
  as.numeric(gsub('injured','',grep('injured',x,value=TRUE)[1])))

mydf$location <- sapply(r5,function(x) {
  end <- length(x)-1
  begin <- max(grep('injured|dead',x))+1
  if (begin==-Inf) print(x) 
  substring(paste(x[begin:end]),2)[1]
})
mydf$dead[is.na(mydf$dead)] <- 0
mydf$injured[is.na(mydf$injured)] <- 0

mydf$state[mydf$state=='Illinois'] <- 'IL'
mydf$state[mydf$state=='Kansas'] <- 'KS'
mydf$state[mydf$state=='Louisiana'] <- 'LA'
mydf$state[mydf$state=='Tennessee'] <- 'TN'
mydf$state[mydf$state=='Maine'] <- 'ME'
mydf$state[mydf$state=='Ohio'] <- 'OH'
mydf$state[mydf$state=='Miss.'] <- 'MS'
mydf$state[mydf$state=='Del.'] <- 'DE'

mydf <- mydf[mydf$state!='PuertoRico',]

mydf$Victims <- mydf$dead+mydf$injured
plot(dead ~ injured,data=mydf)

# How often in a day?
library(ggplot2)

mydf$fDate <- factor(
  levels=as.character(seq(min(mydf$Date),max(mydf$Date),by=1)),
  as.character(mydf$Date))
fperday <- as.data.frame(table(table(mydf$fDate)))
png('freqinday.png')
g1 <- ggplot(fperday,aes(x=Var1,y=Freq))
g1 + geom_bar(stat='identity') +
  labs(x='Number of Shootings',
       y='Number of days') +
  geom_line(data=
              data.frame(Var1=1:7,
                         Freq=dpois(0:6,
                                    lambda=MASS::fitdistr(table(mydf$fDate),
                                                          densfun='Poisson')$estimate)*nrow(mydf)
              ),
            colour='blue')
dev.off()
str(MASS::fitdistr(table(mydf$fDate),
                   densfun='Poisson'))
# # of victims per shooting
mydf$fVictims <- factor(levels=4:max(mydf$Victims),mydf$Victims)
freqdf <- as.data.frame(table(mydf$fVictims))
freqdf$Nvic <- as.numeric(as.character(freqdf$Var1))
library(R2jags)
datain <- list(Victims=mydf$Victims,
               N=nrow(mydf))

Fmodel <- function() {
  for (i in 1:N) {
    Victims[i] ~ dpois(lambda) %_% T(4,)
  }
  lambda ~ dunif( 0, 20)  
}

params <- c('lambda')
inits <- function() {
  list(lambda = runif(1,1,3))
}

jagsfit <- jags(datain, model=Fmodel, inits=inits, parameters=params,
                progress.bar="gui")

#jagsfit
freqdf$exp1 <- dpois(freqdf$Nvic,lambda=2.890)*sum(mydf$Victims)
#2.890
freqdf

#g1 <- ggplot(freqdf,aes(x=Nvic,y=Freq))
#g1 + geom_bar(stat='identity') +
#    labs(x='Number of victims',
#        y='Frequency') +
#    geom_line(data=
#            data.frame(Nvic=4:15,
#                Freq=dpois(4:15,
#                    lambda=2.890)*sum(mydf$Victims)
#            ),
#        colour='blue')

#http://doingbayesiandataanalysis.blogspot.nl/2012/06/mixture-of-normal-distributions.html

Fmodel3 <- function() {
  for (i in 1:N) {
    j[i] ~ dcat(pp) 
    Victims[i] ~ dpois(lambdas[j[i]]  )   %_% T(4,)
  }
  lambda[1] ~ dunif( 0, 20)
  lambda[2] ~ dunif(0,20 )
  lambda[3] ~ dunif(0,20 )
  lambda[4] ~ dunif(0,20 )
  lambdas <- sort(lambda)
  p[1] <- 3
  p[2] <- 3
  p[3] <- 1
  p[4] <- 1
  pp[1:4] ~ ddirch( p )
}

params3 <- c('lambdas','pp')
inits3 <- function() {
  list(lambda = c(runif(1,1,3),runif(1,1,3),runif(1,6,8),runif(1,8,20)))
}

jagsfit3 <- jags(datain, model=Fmodel3, inits=inits3, parameters=params3,
                 progress.bar="gui",n.iter=10000)
#jagsfit3
#mcmc3 <- as.mcmc(jagsfit3)
#par(ask=TRUE)
#plot(mcmc3)

freqdf$exp4a <- sum(mydf$Victims)*dpois(freqdf$Nvic,lambda=0.87)*(.54)
freqdf$exp4b <- sum(mydf$Victims)*dpois(freqdf$Nvic,lambda=3.097)*(.337)
freqdf$exp4c <- sum(mydf$Victims)*dpois(freqdf$Nvic,lambda=7.101)*(.093)
freqdf$exp4d <- sum(mydf$Victims)*dpois(freqdf$Nvic,lambda=15.396)*(.023)


freqdf$exp4 <- freqdf$exp4a+freqdf$exp4b+freqdf$exp4c+freqdf$exp4d
png('numvictim.png')
g1 <- ggplot(freqdf,aes(x=Nvic,y=Freq))
g1 + geom_bar(stat='identity') +
  labs(x='Number of victims',
       y='Frequency') +
  geom_line(data=data.frame(Nvic=freqdf$Nvic,Freq=freqdf$exp1), colour='blue') +
  geom_line(data=data.frame(Nvic=freqdf$Nvic,Freq=freqdf$exp4),colour='purple') 
dev.off()
