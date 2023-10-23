#  Snarky

Snarkyc version 0.5.1

Snarky builds script files for Pumper

Snarky was derived from Sparky, but instead of reading a CSV file, it reads a more powerful JSON file.

Here's some sample JSON:

```
{
    "snarky": "This is a snarky script but you can write any comment here",
    "version": "1.0.0",
    "author": "Bill Donner",
    "date": "Oct 9 2023",
    "purpose": "Generate wierd batches of test messages",
    "topics": [
        {
            "name": "Killers",
            "subject": "Famous Serial Killers",
            "per": 5,
            "desired": 100,
            "pic": "figure.wave",
            "notes": "Enter the twisted minds of history's most notorious figures in a game that will keep you guessing. From unraveling chilling mysteries to putting your detective skills to the test, embrace the dark side as you play the ultimate game of cat and mouse. Can you outsmart the infamous? Only the brave will survive in the world of Famous Serial Killers!"
        },
        {
            "name": "Alchohol",
            "subject": "Types of alcoholic beverages",
            "per": 5,
            "desired": 100,
            "pic": "spigot.fill",
            "notes": "Embrace the Pour-fection! Get ready to raise spirits and craft an unforgettable night as you dive into the world of Alcoholic Adventures. Sip, mix, and shake your way through a boozy journey filled with tantalizing flavors and endless cocktail concoctions. Cheers to interactive fun, where the only hangover you'll have is a craving for more!"
        }
        ]
        }
        ```
        
        This will create a script to pump two topics from ChatGPT, or other AI.
         
Fini

