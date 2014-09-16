# run this program by running `ruby social_network.rb`

require 'set'

# This method will print the social network for a given word.
# The running time for this method is Theta(n + fn + gn) = O(n)
# where n is the number of words in the list, f is the number of 
# friends for the input word, and g is the number of 
# friends of friends. 
def find_social_network(word)

  # Sets to hold all the unique friends, friends of friends, etc.
  friends = Set.new
  friends_friends = Set.new
  friends_friends_friends = Set.new

  # Array to hold all of the words so we don't need to read from the file multiple times
  word_list = []

  # Open the file and store all the words in the array
  f = File.open("randomlist.txt", "r")
  f.each_line do |line|
    word_list.push(line.strip)
  end
  f.close

  # Loops through the list of words, finds all of the friends, and adds them to the set.
  word_list.each do |compare|
    if is_friend(word, compare)
      friends.add(compare)
    end
  end

  # Loops through the list again, and for each friend, find all of its friends, and store these words in a set.
  word_list.each do |compare|
    friends.each do |w|
      if is_friend(w, compare)
        friends_friends.add(compare)
      end
    end
  end

  # Loops through the list a final time for the friends of friends to find the friends of friends of friends. 
  word_list.each do |compare|
    friends_friends.each do |w|
      if is_friend(w, compare)
        friends_friends_friends.add(compare)
      end    
    end
  end

  # Print the social network
  puts "Friends:"
  puts friends.to_a.sort
  puts
  puts "Friends of Friends:"
  puts friends_friends.to_a.sort
  puts
  puts "Friends of Friends of Friends:"
  puts friends_friends_friends.to_a.sort
end


# Method that determines if two words are friends.
# Return true if they are, false if they are not.
def is_friend(word1, word2)

  # Get the difference in length of the words
  difference = (word1.length - word2.length).abs
  
  #If the difference is greater than 1, than the words can't be friends. 
  if difference > 1
    return false

  # If they are the same word, they can't be friends.
  elsif word1 == word2
    return false

  # If the difference in length is 1 or 0 they could potentially be friends.
  elsif difference == 1 or difference == 0

    # Boolean to tell if the words are the same length or not
    same_length = (difference == 0)

    # Determines which word is longer, and stores it in the appropriate place.
    # If they are the same length, word1 will be the "longer" word
    longer_word = (word1.length > word2.length ? word1 : word2)
    shorter_word = (word1.length > word2.length ? word2 : word1)

    # Loop through each letter to compare them, with the maximum index being the length of the longer word
    (0..longer_word.length).each do |i|
      # if the letters are the same, move on
      if word1[i] == word2[i]
        next

      # If they aren't the same, then they are at least one letter off. 
      # Now check to see if they are more than one letter off. 
      else
        # If the mismatched words are the same length, the remainder of each word must match for them to be friends. 
        if same_length
          word1_remainder = word1[i+1...word1.length]
          word2_remainder = word2[i+1...word2.length]

          if word1_remainder == word2_remainder
            return true
          else
            return false
          end

        # If the mismatched words are not the same length, then the remainder of the longer word  
        # must match the remainder of the shorter word, starting from the index where the mismatch occured.
        else
          longer_word_remainder = longer_word[i+1...longer_word.length]
          # Note that the beginning index for the shorter word is `i` instead of `i+1`.
          shorter_word_remainder = shorter_word[i...shorter_word.length]

          if longer_word_remainder == shorter_word_remainder
            return true
          else
            return false
          end
        end
      end
    end
  end

  # This should never be hit, but if it does, return that the two words are not friends. 
  return false
end

print "Input Word: "
word = gets.chomp.strip
find_social_network(word)
