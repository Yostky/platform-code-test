class Award
  attr_accessor :name, :expires_in, :quality
  
  # Award type constants
  BLUE_FIRST = 'Blue First'
  BLUE_COMPARE = 'Blue Compare'
  BLUE_DISTINCTION_PLUS = 'Blue Distinction Plus'
  BLUE_STAR = 'Blue Star'
  
  # Quality constraints
  MIN_QUALITY = 0
  MAX_QUALITY = 50
  
  def initialize(name, expires_in, quality)
    @name = name
    @expires_in = expires_in
    @quality = quality
  end
  
  def update_quality
    return if @name == BLUE_DISTINCTION_PLUS
    
    adjust_quality
    
    @expires_in -= 1
    
    adjust_quality_for_expiration if @expires_in < 0
  end
  
  private
  
  def adjust_quality
    case @name
    when BLUE_FIRST
      increase_quality(1)
      
    when BLUE_COMPARE
      increase_quality(quality_increase_for_blue_compare)
      
    when BLUE_STAR
      decrease_quality(2)
      
    else
      decrease_quality(1)
    end
  end
  
  def adjust_quality_for_expiration
    case @name
    when BLUE_FIRST
      increase_quality(1)  # Gets better with age, even after expiration
      
    when BLUE_COMPARE
      @quality = 0  # Drops to zero immediately after expiration
      
    when BLUE_STAR
      decrease_quality(2)  # Degrades twice as fast = 4 total per day
      
    else
      decrease_quality(1)  # Normal awards degrade twice as fast = 2 total per day
    end
  end
  
  def quality_increase_for_blue_compare
    return 3 if @expires_in <= 5
    return 2 if @expires_in <= 10
    1
  end
  
  def increase_quality(amount)
    @quality = [@quality + amount, MAX_QUALITY].min
  end
  
  def decrease_quality(amount)
    @quality = [@quality - amount, MIN_QUALITY].max
  end
end
