//
//  Endpoints.m
//  clsearch
//
//  Created by Ethan on 11/9/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NSArray *GetDefaultEndpoints()
{
	return [[NSArray alloc] initWithObjects:
				    @"abilene",
				    @"akroncanton",
				    @"albany",
				    @"albanyga",
				    @"albuquerque",
				    @"allentown",
				    @"altoona",
				    @"amarillo",
				    @"ames",
				    @"anchorage",
				    @"annapolis",
				    @"annarbor",
				    @"appleton",
				    @"asheville",
				    @"ashtabula",
				    @"athensga",
				    @"athensohio",
				    @"atlanta",
				    @"auburn",
				    @"augusta",
				    @"austin",
				    @"baltimore",
				    @"batonrouge",
				    @"battlecreek",
				    @"beaumont",
				    @"bellingham",
				    @"bemidji",
				    @"bgky",
				    @"bham",
				    @"bigbend",
				    @"billings",
				    @"binghamton",
				    @"bismarck",
				    @"blacksburg",
				    @"bloomington",
				    @"bn",
				    @"boise",
				    @"boone",
				    @"boston",
				    @"boulder",
				    @"bozeman",
				    @"brainerd",
				    @"brownsville",
				    @"brunswick",
				    @"buffalo",
				    @"butte",
				    @"capecod",
				    @"carbondale",
				    @"catskills",
				    @"cedarrapids",
				    @"cenla",
				    @"centralmich",
				    @"cfl",
				    @"chambana",
				    @"chambersburg",
				    @"charleston",
				    @"charlestonwv",
				    @"charlotte",
				    @"chattanooga",
				    @"chautauqua",
				    @"chicago",
				    @"chillicothe",
				    @"cincinnati",
				    @"clarksville",
				    @"cleveland",
				    @"clovis",
				    @"cnj",
				    @"collegestation",
				    @"columbia",
				    @"columbiamo",
				    @"columbus",
				    @"columbusga",
				    @"cookeville",
				    @"corpuschristi",
				    @"corvallis",
				    @"cosprings",
				    @"dallas",
				    @"danville",
				    @"dayton",
				    @"daytona",
				    @"decatur",
				    @"delaware",
				    @"delrio",
				    @"denver",
				    @"desmoines",
				    @"detroit",
				    @"dothan",
				    @"dubuque",
				    @"duluth",
				    @"eastco",
				    @"easternshore",
				    @"eastidaho",
				    @"eastky",
				    @"eastnc",
				    @"eastoregon",
				    @"easttexas",
				    @"eauclaire",
				    @"elko",
				    @"elmira",
				    @"elpaso",
				    @"enid",
				    @"erie",
				    @"eugene",
				    @"evansville",
				    @"fairbanks",
				    @"fargo",
				    @"farmington",
				    @"fayar",
				    @"fayetteville",
				    @"fingerlakes",
				    @"flagstaff",
				    @"flint",
				    @"florencesc",
				    @"fortcollins",
				    @"fortdodge",
				    @"fortmyers",
				    @"fortsmith",
				    @"fortwayne",
				    @"frederick",
				    @"fredericksburg",
				    @"gadsden",
				    @"gainesville",
				    @"galveston",
				    @"glensfalls",
				    @"grandforks",
				    @"grandisland",
				    @"grandrapids",
				    @"greatfalls",
				    @"greenbay",
				    @"greensboro",
				    @"greenville",
				    @"gulfport",
				    @"harrisburg",
				    @"harrisonburg",
				    @"hartford",
				    @"hattiesburg",
				    @"helena",
				    @"hickory",
				    @"hiltonhead",
				    @"holland",
				    @"honolulu",
				    @"houma",
				    @"houston",
				    @"houston,",
				    @"hudsonvalley",
				    @"huntington",
				    @"huntsville",
				    @"indianapolis",
				    @"iowacity",
				    @"ithaca",
				    @"jackson",
				    @"jacksontn",
				    @"jacksonville",
				    @"janesville",
				    @"jerseyshore",
				    @"jonesboro",
				    @"joplin",
				    @"juneau",
				    @"jxn",
				    @"kalamazoo",
				    @"kalispell",
				    @"kansascity",
				    @"kenai",
				    @"keys",
				    @"killeen",
				    @"kirksville",
				    @"klamath",
				    @"knoxville",
				    @"kokomo",
				    @"kpr",
				    @"ksu",
				    @"lacrosse",
				    @"lafayette",
				    @"lakecharles",
				    @"lakecity",
				    @"lakeland",
				    @"lancaster",
				    @"lansing",
				    @"laredo",
				    @"lasalle",
				    @"lascruces",
				    @"lasvegas",
				    @"lawrence",
				    @"lawton",
				    @"lewiston",
				    @"lexington",
				    @"limaohio",
				    @"lincoln",
				    @"littlerock",
				    @"longisland",
				    @"losangeles",
				    @"louisville",
				    @"loz",
				    @"lubbock",
				    @"lynchburg",
				    @"macon",
				    @"madison",
				    @"maine",
				    @"mankato",
				    @"mansfield",
				    @"marshall",
				    @"martinsburg",
				    @"masoncity",
				    @"mattoon",
				    @"mcallen",
				    @"meadville",
				    @"medford",
				    @"memphis",
				    @"meridian",
				    @"miami",
				    @"milwaukee",
				    @"minneapolis",
				    @"missoula",
				    @"mobile",
				    @"monroe",
				    @"monroemi",
				    @"montana",
				    @"montgomery",
				    @"morgantown",
				    @"moseslake",
				    @"muncie",
				    @"muskegon",
				    @"myrtlebeach",
				    @"nacogdoches",
				    @"nashville",
				    @"natchez",
				    @"nd",
				    @"nesd",
				    @"newhaven",
				    @"newjersey",
				    @"newlondon",
				    @"neworleans",
				    @"newyork",
				    @"nh",
				    @"nmi",
				    @"norfolk",
				    @"northernwi",
				    @"northmiss",
				    @"northplatte",
				    @"nwct",
				    @"nwga",
				    @"nwks",
				    @"ocala",
				    @"odessa",
				    @"okaloosa",
				    @"oklahomacity",
				    @"olympic",
				    @"omaha",
				    @"oneonta",
				    @"onslow",
				    @"orangecounty",
				    @"oregoncoast",
				    @"orlando",
				    @"ottumwa",
				    @"outerbanks",
				    @"owensboro",
				    @"panamacity",
				    @"parkersburg",
				    @"pennstate",
				    @"pensacola",
				    @"peoria",
				    @"philadelphia",
				    @"phoenix",
				    @"pittsburgh",
				    @"plattsburgh",
				    @"poconos",
				    @"porthuron",
				    @"portland",
				    @"potsdam",
				    @"prescott",
				    @"pueblo",
				    @"pullman",
				    @"quadcities",
				    @"quincy",
				    @"racine",
				    @"raleigh",
				    @"rapidcity",
				    @"reading",
				    @"reno",
				    @"richmond",
				    @"richmondin",
				    @"rmn",
				    @"roanoke",
				    @"rochester",
				    @"rockford",
				    @"rockies",
				    @"roseburg",
				    @"roswell",
				    @"sacramento",
				    @"saginaw",
				    @"salem",
				    @"salina",
				    @"sanangelo",
				    @"sanantonio",
				    @"sandiego",
				    @"sandusky",
				    @"sanmarcos",
				    @"santafe",
				    @"sarasota",
				    @"savannah",
				    @"scottsbluff",
				    @"scranton",
				    @"seattle",
				    @"seks",
				    @"semo",
				    @"sfbay",
				    @"sheboygan",
				    @"showlow",
				    @"shreveport",
				    @"sierravista",
				    @"siouxcity",
				    @"siouxfalls",
				    @"skagit",
				    @"smd",
				    @"southbend",
				    @"southcoast",
				    @"southjersey",
				    @"spacecoast",
				    @"spokane",
				    @"springfield",
				    @"springfieldil",
				    @"statesboro",
				    @"staugustine",
				    @"stcloud",
				    @"stgeorge",
				    @"stillwater",
				    @"stjoseph",
				    @"stlouis",
				    @"swks",
				    @"swmi",
				    @"swv",
				    @"swva",
				    @"syracuse",
				    @"tallahassee",
				    @"tampa",
				    @"terrehaute",
				    @"texarkana",
				    @"texoma",
				    @"thumb",
				    @"tippecanoe",
				    @"toledo",
				    @"topeka",
				    @"treasure",
				    @"tricities",
				    @"tucson",
				    @"tulsa",
				    @"tuscaloosa",
				    @"tuscarawas",
				    @"twinfalls",
				    @"twintiers",
				    @"up",
				    @"utica",
				    @"valdosta",
				    @"victoriatx",
				    @"waco",
				    @"washingtondc",
				    @"waterloo",
				    @"watertown",
				    @"wausau",
				    @"wenatchee",
				    @"westernmass",
				    @"westky",
				    @"westmd",
				    @"westslope",
				    @"wheeling",
				    @"wichita",
				    @"wichitafalls",
				    @"williamsport",
				    @"wilmington",
				    @"winchester",
				    @"winstonsalem",
				    @"worcester",
				    @"wv",
				    @"yakima",
				    @"york",
				    @"youngstown",
				    @"yuma",
				    @"zanesville",
				    nil];
}
