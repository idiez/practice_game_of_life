#encoding: utf-8

class Grid

  attr_accessor :cells

  def initialize(raw_grid)
    @cells = []
    raw_grid.each_with_index { |row, i| 
      row.each_with_index { |raw_cell, j| 
        @cells << Cell.new(raw_cell, [i, j]) 
      } 
    }
    @cells.each { |cell| 
      @cells.each { |alien_cell|
        if cell.is_neighbor?(alien_cell) then cell.welcome_neighbor(alien_cell) end
      }  
    }
  end

  def evolve
    @cells.each { |cell| cell.evolve }
    @cells.each { |cell| cell.update }
  end

  def is_center_alive?
    return @cells[@cells.length/2].is_alive?
  end

  def raw
    last_cell_position = @cells.last.position
    raw_grid = Array.new(last_cell_position.first + 1) { Array.new(last_cell_position.last + 1) }
    @cells.each { |cell| raw_grid[cell.position.first][cell.position.last] = cell.to_s }
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

  def welcome_neighbor(cell)
    @neighbors << cell
  end

  def evolve
    count = @neighbors.select(&:is_alive?).count
    if is_alive?
      if count < 2               #rule 1       
        @next_state = die
      elsif count.between?(2,3)  #rule 2
        @next_state = live
      else                       #rule 3 (count > 3)
        @next_state = die
      end
    else
      if count == 3              #rule 4
        @next_state = live
      else
        @next_state = die
      end
    end
  end

  def update
    @alive = @next_state
  end

  def is_alive?
    return @alive
  end

  def is_neighbor?(alien_cell)
    unless (@position[0] - alien_cell.position[0]).abs > 1 \
     or (@position[1] - alien_cell.position[1]).abs > 1 \
     or @position == alien_cell.position
      return true
    else
      return false
    end
  end

  def live
    return true
  end

  def die
    return false
  end

  def to_s
    if is_alive?
      return "x"
    else
      return "."
    end
  end

end 