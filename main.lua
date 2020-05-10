--TODO: verifier la position de la pillule ( n'apparait pas toujours)

score = 0
timePast = 0.2
dead = false
function createTrain(x,y)
  t = {}
  return t
end

function createWagon(x,y)
  w = {}
  w.x = x
  w.y = y
  w.draw = function(self)
    love.graphics.rectangle('fill', self.x , self.y, size, size)
  end
  w.reached = function(self, x, y) -- verifie si l'objet atteint la position 
    if self.x == x and self.y == y then
      return true
    end
  end
  w.border = function(self)
    if self.x >= WIDTH then
      self.x = 0
    elseif self.x <= 0 then
      self.x = WIDTH
    end

    if self.y >= HEIGHT then
      self.y = 0
    elseif self.y <= 0 then
      self.y = HEIGHT
    end
  end
  return w
end

function selfCollision(wagon,table)
  for k in pairs(table) do
    if wagon.x  == table[k].x and wagon.y == table[k].y then
      return true
    end
  end
end

function createPill()
  p = {}
  p.x = ((love.math.random(1, WIDTH/size) - 1) * size)
  p.y = ((love.math.random(1, HEIGHT/size) - 1) * size)
  p.draw = function(self)
    love.graphics.push()
    love.graphics.setColor(0,100,0,100)
    love.graphics.rectangle('fill', p.x ,p.y, size, size)
    love.graphics.pop()
  end
  return p
end



  
function love.load()
  love.math.setRandomSeed( love.timer.getTime() )
  WIDTH = love.graphics.getWidth()
  HEIGHT = love.graphics.getHeight()
  -- preparation du texte
  myFont = love.graphics.newFont('fonts/Anton-Regular.TTF',20)
  myDeadFont = love.graphics.newFont('fonts/COMICATE.TTF', 50)
  
  

  train = {} -- conteneur pour les wagons
  size = 20 -- taille d'un wagon
  dir = {x = 0 , y = -1 } -- direction à incrementer toute les secondes
  grow = false -- empeche de grandir
  w = createWagon(400,400) -- creation du premier wagon 
  p = createPill() -- creation d'une pillule
  timeCounter = love.timer.getTime() -- instaciation du compteur

  table.insert(train,w) -- train avec un wagon

  

  
end


function love.update(dt)
  if timeCounter + timePast > love.timer.getTime() then
    -- do nothing
  else 
    -- TODO: verifier la collision avec lui même

    -- créé un wagon à la direction suivante et l'insert dans la table train
    a = createWagon(train[#train].x + dir.x * size, train[#train].y + dir.y * size)
    a:border()

    if selfCollision(a, train) then
      dead = true
    end

    table.insert(train,a) 



    if a:reached(p.x, p.y) then -- si la position de la pillule est atteinte
      grow = true -- il grandit
      score = score + 1 -- on ajoute un au score
      p = createPill() -- creation d'une nouvelle pillule
      timePast = timePast - 0.01-- on accelere
    end
    if grow == false then
      table.remove(train,1)
    end
    -- on oubli pas de remettre le compteur temps à 0
    timeCounter = love.timer.getTime()
    grow = false
  end
  

end

function love.keypressed(key)
    if key == 'up' then
      dir.y = -1
      dir.x = 0
    end
    if key == 'down' then
      dir.y = 1
      dir.x = 0
    end
    if key =='left' then
      dir.x = -1
      dir.y = 0
    end
    if key =='right' then 
      dir.x = 1
      dir.y = 0
    end
    if key == "escape" then
      love.event.quit() -- Pour quitter le jeu
    end
    if key == 'space' then
      -- redemmarrer le jeu
      if dead then 
        -- redemarre le jeu
        train = nil
        a = nil
        love.load()
        dead = false

        else
        -- nothing
      end
    end
    
end

function love.draw()
  if dead then
    myDeadTxt1 = love.graphics.newText(myDeadFont,"VOUS AVEZ PERDU!!!")
    myDeadTxt2 = love.graphics.newText(myDeadFont,"SCORE : "..score)
    myDeadTxt3 = love.graphics.newText(myFont,"pour rejouer, appuyer sur la barre espace")
    love.graphics.draw(myDeadTxt1, WIDTH/2 - 250, HEIGHT/2)
    love.graphics.draw(myDeadTxt2, WIDTH/2 - 140, HEIGHT/2 +60)
    love.graphics.draw(myDeadTxt3, WIDTH/2 - 190, HEIGHT/2 +120)
    -- vous avez perdu
  else
    -- dessine la pillule
    p.draw()
    -- dessine le train
    for i,v in ipairs(train) do
      alpha = 1 - (#train - i )*0.05 -- l'alpha depends de la position dans la table 
      -- ( plus on est loin de la fin de la table plus l'alpha est petit ) 
      love.graphics.setColor(1,1 - alpha,1 - alpha)
      v:draw()
    end
    -- affiche le score
    love.graphics.push()
    myScore = love.graphics.newText(myFont,'SCORE : '..score)
    love.graphics.setColor(100,100,100,100)
    love.graphics.draw(myScore, WIDTH/2,20)
    love.graphics.pop()
  end
end
