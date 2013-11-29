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
    @cells.each { |cell| cell.nextState }
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
    order_h = order.ceil
    order_v = order.floor
    raw_grid = Array.new(order_v) { Array.new(order_h) }
    @cells.each_with_index { |cell, i|
      if cell.isAlive? 
        raw_grid[i/order_h][i%order_h] = "x"
      else 
        raw_grid[i/order_h][i%order_h] = "."
      end
    }
    return raw_grid
  end

end

class Cell

  attr_accessor :alive, :next_state, :position, :neighbors

  def initialize(state, position)
    if state == "."
      @alive = false
    else
      @alive = true
    end
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
        @next_state = false
      elsif count.between?(2,3)  #rule 2
        @next_state = true
      else                       #rule 3 (count > 3)
        @next_state = false
      end
    else
      if count == 3              #rule 4
        @next_state = true
      else
        @next_state = false
      end
    end
  end

  def evolve
    @alive = @next_state
  end

  def position
    return @position
  end

  def isAlive?
    return @alive
  end

  def to_s
    str =  "Cell: position (#{@position[0]}, #{@position[1]}), is alive? #{@alive}, neighbors position "
    unless @neighbors.empty?
      @neighbors.each { |cell| str = str + "(#{cell.position[0]}, #{cell.position[1]}), "}
      return str[0,str.length - 2]
    else
      return str[0,str.length - 21]
    end
  end

end 