# Batcomputer_Database
Swift underlying structure for a simple batcomputer database app, containing information on popular characters.

* For development a LAMP stack was created on an Ubuntu OS Virtual Machine that hosted the mySQL data base. The data base contents are present in the batcomputer_data.txt file.
* I also created a simple CRUD API in python that is hosted on the Ubuntu OS that interracts with the swift in a clean and secure manner, allowing for user sign in capability while also limiting other's privileges.
* The database is simple and contains a list of fictional characters and their attributes, with the goal being to create a fun app that can pit their stats against each other and settle debates between friends on who would win a fight.

#Database Structure
* Column Descriptors:
  * id: A unique identifier for each character.
name: The superhero's alias or code name.
intelligence: A numerical representation of the character's intelligence level.
strength: A numerical value representing the character's physical strength.
speed: A numerical representation of how fast the character can move.
durability: A measure of the character’s resilience and ability to withstand damage.
power: A numerical value representing the character's overall power or abilities.
combat: A score depicting the character’s combat skills and experience.
full-name: The character’s real or full name, as opposed to their superhero alias.
alter-egos: Any other identities the character has used.
aliases: Alternate names or titles the character is known by.
place-of-birth: The location where the character was born or created.
first-appearance: The comic issue or media in which the character made their first appearance.
publisher: The company responsible for creating and publishing the character.
alignment: Whether the character is good, evil, or neutral.
gender: The gender of the character.
race: The character's species or race (e.g., human, mutant, alien).
height: The character’s height, often given in both feet and centimeters.
weight: The character’s weight, often provided in both pounds and kilograms.
eye-color: The color of the character’s eyes.
hair-color: The color of the character’s hair.
occupation: The character’s primary job or role, either before or alongside their superhero activities.
base: The main location where the character operates from.
group-affiliation: Teams, organizations, or alliances the character is part of.
relatives: Important family members related to the character.
url: A link to an image of the character or more detailed information.
