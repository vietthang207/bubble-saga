CS3217 Problem Set 5
==

**Name:** Dinh Viet Thang

**Matric No:** A0126513N

**Tutor:** Nguyen Quoc Dat

### Rules of Your Game

Note: every time a bubble explode, it will fade away instead (since I haven't implement the explode animation)

Tap to fire a bubble, it travels in constant speed. Upon reaching the grid, it will activate 
special effect of bubbles that it come to contact. If it can form a connected component of 3 
bubble of the same colour, they will explode (fading). Any bubble that left in the mid air will 
fall down. If the projectile cannot find a place to snap into, it will fall instead. Falling bubbles
will never collide with anything, and will be remove once they reach the ground.

Every time a bubble explode or fall, user gain 1 score. Game over reached when user has fire 1000 bubbles.
Note that if the level designed to have some bubble in mid air, they will fall when the level begins, 
and user also been credit for score. 


### Problem 1: Cannon Direction

User can tap into any point in the game area, the cannon will instantly rotate to face that direction
and fire a projectile.
User can also use pan gesture to rotate the cannon, when use release their finger, 
the cannon will shot at the current direction.


### Problem 2: Upcoming Bubbles

3 upcoming bubbles will be showned in a queue order. The cannon will load the closest bubble,
the other bubble will move to the right. Another bubble will be created and push to the queue
(except when the bubble limit of the game level reached)


### Problem 3: Integration

I integrate mostly by copy-paste code from ps3 and ps4.
When user press START, another view will be shown, this view is controlled by 
an GamePlayViewController, game level name or bubbles' data will be pass for this 
GamePlayViewController in prepare for segue. Both LevelDesignerViewController and 
GamePlayViewController are being embedded in a UINavigationController.

The advantages of using UINavigationController is that I don't have to implement 
the navigation buttons.
My ps3 and ps4 share some datastructure so I can reuse them for both GamePlayViewController
and LevelDesignerViewController.
My ps3 use CollectionView while ps4 does not (since I want to try new approach). If I reuse 
the CollectionView code from ps3 to ps4, they will share even more datastructure.

The disadvantages of my approach is GamePlayViewController and LevelDesignerViewController
share a lots of similar function (e.g. loadBackGround), I will need to do a lots of refactoring.
When we switch between ViewController, a lots of data being reload (e.g. the background) which is 
inefficient. If I use another approach which make the backgroundImage a view that is in the bottom
of the stack view, then I don't need to reload it.


### Problem 4.3

My strategy: 
- Try to find the connected component of 3 or more same color bubbles first.
- If a special bubble that come to contact with the snapped bubble, it will be pushed it into a queue (called chain).
- While the queue is not empty, dequeue to first element and activate its effect. If the effect that make any 
other special bubbles explode, it will be pushed to the queue, waiting to be activated.

My strategy is hard to have bugs since every effect will be fully activated before activating other bubbles' effect.
For example, if a lightning bubble that activate a bomb, then the bomb's effect will be delayed until the lightning's 
effect completed. If I use a different aproach which activate the bomb right after it explode, then the effect of the 
lightning bubble will be interrupted, resuming it later can be buggy.


### Problem 7: Class Diagram

Please save your diagram as `class-diagram.png` in the root directory of the repository.

### Problem 8: Testing

Black-box testing

I. Test Game Menu

II. Test Level Designer

	1. Testing implement of the palette:

		a. Select 1 button on pallets, it will be highlighted, select it again will bring it back to normal
		   repeat for all buttons

	2. Testing implement of the game:

		a. Test tap gesture:
		- Tapped everything outside the pallete and control panel, nothing should happen
		- Tap a button from palette, tapped on any bubble on the collection, this bubble should change colour to selected type (or empty if we chose eraser).
		  Repeat for all button from palette
		- Deselect the button on the pallette, tapped on a colored bubble on the grid, 
		  the colour of this bubble should follow the circle blue->green->orange->red->blue->bomb->indestructible->lightning->star

		b. Test pan gesture:
		- Not choose any colours/eraser, pan across the grid, nothing should happened.
		- Chose a colour on the palette: pan across the collection, the bubbles we panned should be filled with the selected type,
		  pan outside collection area, nothing should be changed.
		- Chose the erase button on the palette: pan across the collection, 
		  the filled bubbles on the grid we panned should be clear to empty,
		  pan outside collection area, nothing should be changed.

		c. Test long-pressed gesture
		- Long pressed outside grid, nothing should happen
		- Long pressed an empty bubble, nothing should happen
		- Long pressed a filled bubble, the bubble should change to be empty
		- Select some buttons on the pallette, repeat all 3 steps above, it would behave the same way.

	3. Test implement of file operation

		a. Test loading with no saved level.
		+ Press load, a popup should tell you that there's no save game level to load.

		b. Test save with an invalid name
		+ Press save button, should see the alert view with a text field to type a name
		+ Not type any name or type a spaces only, press save, should see the alert view again with warning message.
		+ Enter some spaces, press save on the allert, we should see the warning message as well


		c. Test save/load 1 game level:
		+ Filled some bubbles with some colours (for example, red)
		+ Press save buttons, should see alert view to type the name, save it with a name (for example: “red”), should see the successful message
		+ Reset (click Reset button)
		+ Press load, an option menu shown up
		+ Press the game level name
		+ The grid should be loaded like when we save it

		d. Test having current game level:
		+ Modify some bubble (or clear all and add other color, i.e. blue)
		+ Press save, an alert will be poped which has 3 options overwrite, save as or cancel
		+ choose save as (i.e. "blue")
		+ Load both red and blue to see whether they are correct
		+ Repeat, but this time choose overwrite
		+ Load both red and blue to see whether they are correct

		e. Test save a game level with an existed game level name
		+ Modify some bubble (or clear all and add other color, i.e. orange)
		+ Press save, an alert will be poped which has 3 options overwrite, save as or cancel
		+ Choose save as and keyin an existing name (i.e. "blue") an alert should shown up 
		  and ask you whether you want to overwrite or save as another name
		  Try 1 option, load the levels to check whether they are correct
		  Retry with the other option.


	4 Test implement of reset

		+ Fill bubbles with some colours
		+ Press reset, should see an alert which has 2 options yes or no
		+ Press yes, should see the bubble collection view changed to default state
		+ Repeat, but choose no, nothing should happen after.

III. Test Game Play

	1. Test launching bubble:
		- Tap a point above the origin to make a bubble flying upward, bubble should be launched 
			to the target point
		- Tap a point below the origin, nothing should happened
		- Repeat the 2 steps above with pan gesture 

	2. Test tap gesture
		- Tap any point on the game area, the cannon should rotate to the direction immediately
			and fire a bubble
	
	3. Test pan gesture
		- Panning though the game area, the cannon should rotate follow your finger.
		- Release the pan, the cannon should stop and fire the bullet.

	4. Test upcomming bubbles queue:
		- When the game play view loaded, there should be 1 bubble loaded to the cannon and 3 
			in the queue
		- Tap to fire the loaded bubble. After that, the nearest bubble will be loaded to the cannon,
			other bubbles in the queue will be moved to the right, a new bubble with random color will
			be created on the left most of the queue. Repeat this step several times.
		- Try to play until the bubble limit reached, after that, no bubble should be created.
			This can be done faster if we can set the bubble limit of the level to be low.

	5. Test bubble movement: 
		- Tap to launch a bubble toward right wall, it should reflect when contacted with the wall.
			The bubble should always maintain a constant speed.
		- Repeat with left wall
		- If the projectile touch the ceiling, it should stop when contacted with the ceiling
			and snap to the nearest empty cell
		- If the projectile touch any existed bubble, it should stop when contacted with that bubble
			and snap to the nearest empty cell
		- A bubble will be created at the origin (launching point) when the projectile stop and snap 
			to the empty cell

	6. Test multiple bubbles:
		- Quickly tap to launch a few bubbles, all of them should be launch and moved normally.
		- Fire some bubble so that they will collide. The collision should looks like elastic collision.
			This step can be done easy if we can launch several bubbles with nearly-horizontal angle,
			then launch a few bubble with 40-90 degree, they are very likely to collide.
		- Try to make some bubble move downward by collision, they should disappear once they reach the bottom.

	7. Test projectile creation: 
		- Try to launch several bubbles, observe their color to see if it is a reasonably random bubble generator.

	8. Test removing bubble if they form a group of 3
		- Try to play and launch bubbles so that they can form a group of 3 with the same color, 
			they should disappear with an animation.
		- Also try to play so that some bubble will be left in mid air, they should fall down and disappear.
			No special bubble's effect activated.

	9. Test bomb bubble
		- Create a level contains of some bomb and other bubbles. Fire a bubble to the bomb. 
			The bomb and it's neighbor should explode (except indestructible and star bubble).
			All exploding bubble's special effect will be chained.
		- Any bubble left in mid will fall down and disappear. No special effect of falling bubble will be activated.

	10. Test lightning bubble
		- Create a level contains of some lightning and other bubbles. Fire a bubble to the lightning bubble. 
			All the bubble in the same row with the lightning (except indestructible and star bubble) should explode.
			All exploding bubble's special effect will be chained.
		- Any bubble left in mid will fall down and disappear. No special effect of falling bubble will be activated.
		- Create a case where the projectile snap into the row above the lightning, but it still touch the lightnign bubble
			(a bit hard, should make use of the reflection on the wall to achieve this case)
			The lightning bubble's effect should be activated, but the projectile left untouch since it is not on the same row.

	11. Test star bubble
		- Create a level contains of some star and other bubbles. Fire a bubble to the star bubble. 
			All the bubble of the same color with the projectile (except indestructible and star bubble).
		- Any bubble left in mid will fall down and disappear. No special effect of falling bubble will be activated.

	12. Test projectile activate multiple explosion
		- Fire a bubble so that it will snap next to several bubble with effects (bomb, lightning, star), all of the 
			effects should be activated.
		- Fire a bubble so that it will snap next to several bubble with effects (bomb, lightning, star),
			and it also form a connected component of 3 or more bubbles of the same colour. The connected component
			should explode and all of the effects should be activated.

	13. Test game over:
		- Try to play so that one bubble will end up below the red line, an alert should appear with the message
			"Game over!". After that, the endgame screen should appear.
		- Try to play to reach the bubble limit, the same Game over alert and endgame screen should appear.

Glass-box testing

I Test BubbleView

	1. Test getImageForBubbleType
	+ getImageForBubbleType(BubbleType.empty)
	+ For each bubble color: getImageForBubbleType(type)

II Test GridViewController

	1. Test initialization

	2. Test reset()

	3. Test changeBubbleByIndexPath

	4. Test cycleBubbleTypeByIndexPath
		+ test with empty bubble
		+ test with all bubble type

	5. Test getSavableGameLevelObj

	6. Test loadGameLevel

III. Test physics engine

	a. Test projectile
		- Create a projectile object with some non-zero velocity
		- Call reflect(), velocity in x axis should change sign.
		- Call advance(timeStep), velocity shoudld be the same, center will be moved by velocity*timeStep
		- Call stop(), velocity should be a vector 0, and isMoving() should return false.

	b. Test Collidable
		- Create a projectile object with some non-zero velocity
		- Create a HorizontalCollidable
		- Set the projectile center, radius so that it will collide with the Collidable
		- Call willCollide, it should return true. The projectile should stop after collision.
		- Repeat with VerticalCollidable (projectile reflect after collision) and CircleCollidable (projectile stop after collision).

	c. Test Math
		- Write some unitest for CGVector and CGPoint extension.

IV. Test graph

	a. Test getAndDeleteConnectedComponentOfTheSameColorAt
		- Use changeBubbleTypeAt to set some bubble
		- Run getAndDeleteConnectedComponentOfTheSameColorAt and check the result
		- Need to create all the cases:
			+ empty grid, should return empty array
			+ no group of at least 3 same color bubble formed, should return empty array
			+ a group of at least 3 same color bubble formed, should return the connected component indexes.

	b. Test getAndRemoveMidAirBubbles
		- Use changeBubbleTypeAt to set some bubble
		- Run getAndRemoveMidAirBubbles and check the result
		- Need to create all the cases
			+ empty grid, should return empty array
			+ no bubble in mid air, other bubble form only 1 connected component, should return empty array
			+ no bubble in mid air, other bubble form more than 1 connected component, 
				should return all indexes of mid air bubbles.
			+ some bubbles in mid air and they are connected, should return all indexes of mid air bubbles.
			+ some bubbles in mid air and they are not connected, should return all indexes of mid air bubbles.

	c. Test activateSpecialBubblesAdjacentTo
		- Use changeBubbleTypeAt to set some bubble
		- Run activateSpecialBubblesAdjacentTo and check the result
		- Need to create all the cases
			+ empty grid, should return empty array

V. Test queue
	//same as ps1

VI. Test Util

	a. Test getCenterForBubbleAt
		- Test some bubble in the middle with both even row and odd row(example: (row=4, col=5), (row=5, col=6))
		- Test boundary case: (row=0, col=0), (row=0, col=11), (row=8, col=0) , (row=8, col=11)
	
	b. Test getRandomBubbleType
		- Call the function for many times (i.e. 100), count the bubble of each type
		- Calculate the probability for each type, justify the result

### Problem 9: The Bells & Whistles

- Exploding bubbles will fade while mid air bubble will fall out of the screen
- Projectiles that cannot find a cell to snap into will fall out of the screen
- Game score
- Endgame alert
- Limited number of bubbles.
- A queue to determine upcoming bubbles. New bubble will be pushed to the queue
when we still have bubbles left.


### Problem 10: Final Reflection

If game engine use CollectionView just like the level designer, it will be even better since they will share 
a lots more datastructure and method in common. I also need to refactor my code.