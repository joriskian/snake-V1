# snake-V1
A short snake's game-like in Lua (with love2D)

This snake is made of an array of block.
Each block has a x and y positions changed by velocity.

Each time the positions are changed, I push the new block in the array and delete the first one.
When the snake grow I don't delete the first.

Several methods are sets for manage collisions and randomly add a new pill to eat.

When eating a pill the snake accelerate( the timeLapse loop is decreamenting).

