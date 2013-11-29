#encoding: utf-8

class Grid

  attr_accessor :cells

  def initialize(raw_grid)
    @cells = []
    raw_grid.each_with_index { |row, i| 
      raw_grid[i].each_with_index { |raw_cell, j| 
        @cells << Cell.new(raw_cell, [i, j]) 
      } 
    }

    @cells.each { |cell| 
      @cells.each { |alien_cell|
        if areNeighbor(cell, alien_cell) 
          cell.welcomeNeighbor(alien_cell)
        end
      }  
    }
  end

  def evolve
    @cells.each { |cell| cell.next_state }
    @cells.each { |cell| cell.evolve }
  end

  def isCenterAlive?
    return @cells[@cells.length/2].isAlive?
  end

  def areNeighbor(cell_1, cell_2)
    unless (cell_1.position[0] - cell_2.position[0]).abs > 1 or (cell_1.position[1] - cell_2.position[1]).abs > 1 or cell_1.position == cell_2.position
      return true
    else
      return false
    end
  end

  def raw
    order = Math.sqrt(@cells.length)
    raw_grid = Array.new(order, Array.new(order))
    @cells.each_with_index { |cell, i| 
      if cell.isAlive? 
        raw_grid[i/order][i%order] = "x"
      else 
        raw_grid[i/order][i%order] = "."
      end
    }
    return raw_grid
  end

end

class Cell

  attr_accessor :aliv, :next_state, :position, :neighbors

  def initialize(state, position)
    state == "." ? @aliv = :dead : @aliv = :alive
    @position = position
    @neighbors = []
  end

  def welcomeNeighbor(cell)
    @neighbors << cell
  end

  def nextState
    count = @neighbors.select{ |cell| cell.isAlive? }.count
    if isAlive?
      if count < 2               #rule 1       
        @next_state = :dead 
      elsif count.between(2,3)   #rule 2
        @next_state = :alive
      else                       #rule 3 (count > 3)
        @next_state = :dead
      end
    else
      if count == 3              #rule 4
        @next_state = :alive
      else
        @next_state = :dead
      end
    end
  end

  def evolve
    @aliv = @next_state
  end

  def position
    return @position
  end

  def isAlive?
    return @aliv == :alive
  end

end 