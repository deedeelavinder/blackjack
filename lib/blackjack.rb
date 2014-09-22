class Player
  attr_accessor :p_name
  attr_accessor :p_bet
  attr_accessor :p_acct

  def initialize
    @p_name = p_name
    @p_bet = p_bet
    @p_acct = p_acct
  end

  def get_name
    puts "What is your name?"
    @p_name = gets.chomp
    greeting
  end

  def greeting
    puts "Would you like to play some BlackJack?  I'm dealing."
    answer = gets.chomp.downcase
    if answer == "yes" || answer == "y"
      first_bet
    else
      puts "Bummer! I thought you would at least give it a try!"
      exit
    end
  end

  def first_bet
    @p_bet = 0
    @p_acct = 100
    while @p_bet == 0 || @p_bet < 10
      puts "Let's start you off with $100. What would you like to bet? (Minimum bet is $10.)"
      @p_bet = gets.chomp.to_i
    end
    @p_acct = 100 - @p_bet
  end
end

@player = Player.new
@player.get_name


class Deck
  attr_accessor :rank, :suit, :deck, :value

  def initialize
    @rank = ["Ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King"]
    @suit = ["of Hearts", "of Diamonds", "of Clubs", "of Spades"]
    @deck = [1,2]
    @value = value
  end

  def shuffle_deck
    @deck = (rank.product(suit)).shuffle
    # value_hash
    print "shuffled deck"
    print "deck #{@deck}"
    return @deck
  end

  def value_hash
    @value = {}
    card_values
  end

  def card_values
    @value = {"Ace" => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10, "Jack" => 10, "Queen" => 10, "King" => 10}
  end
end

@deck_o_cards = Deck.new
@deck_o_card2 = Deck.new
@deck_o_cards.shuffle_deck


class Hand
  attr_accessor :p_hand
  attr_accessor :d_hand

  def initialize
    @p_hand = []
    @d_hand = []
  end

  def initial_deal
    print "initial deal"
    2.times {@p_hand << @deck_o_cards.deck.pop}
    2.times {@d_hand << [1,2].pop}
  end
end

new_hand = Hand.new
new_hand.initial_deal

class Play
  def initialize
    @p_hand_sum = p_hand_sum
    @d_hand_sum = d_hand_sum
    @blackjack = 21
  end

  def play_game
    puts "Here is your hand: #{@p_hand[0]} and #{@p_hand[1]}"
    puts "Here is my hand: 'X' and #{@d_hand[1]}"
    sum_p_hand
    sum_d_hand
  end

  def p_black_jack
    if @p_hand_sum == @blackjack
      puts "WOW, #{@p_name}, you have BlackJack!"
      d_black_jack
    else
      eval_p_hand
    end
  end

  def calculate_total (hand)
    hand_sum = 0
    hand.collect {|ind| ind[0]}.each do |element|
      if element == "Jack" || element == "Queen" || element == "King"
        hand_sum += 10
      elsif element == "Ace"
        hand_sum += 11
      else
        hand_sum += element
      end
    end
    hand.collect {|ind| ind[0]}.each do |element|
      if hand_sum > 21 && element == "Ace"
        hand_sum -= 10
      end
    end
    return hand_sum
  end

  def sum_p_hand
    calculate_total (@p_hand)
    @p_hand_sum = hand_sum
    eval_p_hand
  end

  def sum_d_hand
    calculate_total (@d_hand)
    @d_hand_sum = hand_sum
  end

  def eval_p_hand
    if @p_hand_sum > 21
      p_bust
    else
      hit_or_stand
    end
  end

  def p_bust
    Puts "Bummer, #{@p_name}! Your hand equals #{@p_hand_sum} and you BUST!"
    p_pays
  end

  def hit_or_stand
    loop do
      puts "#{@p_name}, would you like to hit(h) or stand(s)?"
      answer = gets.chomp.downcase
      if answer == "h" || answer == "hit"
        @p_hand << :deck.shuffle.pop
        sum_p_hand
      elsif answer == "s" || answer == "stand"
        puts "Okay, you stand. Let's see what I've got."
        d_black_jack
      else
        puts "I didn't understand your response."
      end
    end
  end

  def d_bust
    puts "My hand equals #{@d_hand_sum} and I BUST. You win!"
    d_pays
  end

  def d_finish
    loop do
      sum_d_hand
      puts "My hand equals #{@d_hand_sum}."
      if @d_hand_sum < 17
        puts "I'll take another."
        @d_hand << @deck.shuffle.pop
        sum_d_hand
      elsif @d_hand_sum >= 17
        puts "My hand equals #{@d_hand_sum}."
        win_or_lose
      elsif @d_hand_sum > 21
        d_bust
      end
    end
  end

  def d_black_jack
    if @d_hand_sum == @blackjack
      puts "WOW, I have #{@d_card[1]} and #{@d_card[2]}.  That's BlackJack!."
      win_or_lose
    else d_finish
    end
  end

  def win_or_lose
    if @p_hand_sum == @blackjack && @d_hand_sum == @blackjack
      push_g_over
    elsif @p_hand_sum == @blackjack
      d_pays_bj
    elsif @d_hand_sum > @p_hand_sum
      p_pays
    elsif @d_hand_sum < @p_hand_sum
      d_pays
    else
      push_g_over
    end
  end

  def d_pays_bj
    @p_bet = @p_bet * 1.5
    puts "You won $#{@p_bet}."
    @p_acct += @p_bet
    puts "You now have $#{@p_acct}."
    play_again
  end

  def d_pays
    puts "You won $#{@p_bet}."
    @p_acct += @p_bet
    puts "You now have $#{@p_acct}."
    play_again
  end

  def p_pays
    puts "I won! You lost $#{@p_bet}."
    @p_acct -= @p_bet
    puts "You now have $#{@p_acct}."
    play_again
  end

  def push_g_over
    puts "That's a push. You didn't win or lose."
    puts "You still have $#{@p_acct}."
    play_again
  end

  def play_again
    puts "Would you like to play again?"
    answer = gets.chomp.downcase
    if answer == "yes" || answer == "y"
      bet_again
    else
      puts "Thanks for playing!"
      exit
    end
  end

  def bet_again
    @p_bet = 0
    while @p_bet == 0 || @p_bet < 10
      puts "How much would you like to bet? (Minimum bet is $10.)"
      @p_bet = gets.chomp.to_i
    end
    @p_acct = @p_acct - @p_bet
    play_game
  end
end
new_game = Play.new
new_game.play_game
