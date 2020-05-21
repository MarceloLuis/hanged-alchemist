defmodule Game do
    @moduledoc """
    Provides the functions from a hangman 
    """

    @doc """
    Made a list of "-" whit the same size of a Word
    ## Parametres
        - Letter_list: List of all letters of a Word
    ## Exemple
          iex> Game.turn_ocult("Marcelo")
          ["-", "-", "-", "-", "-", "-", "-"]    
    """
    def turn_ocult(letter_list), do: Enum.map(letter_list, fn _ -> "-" end)
    
    @doc """
    Verife if the the letter gived by the user exists in the orinal word, and switch the "-" in the ocult from the word in the same index
    Used just from @check_letter.
    ## Parametres
        - {Value, Ocult}
            - Value: Char that represents the atual letter of the word
            - Ocult: Char that represents the atual letter of the ocult list
        - Value: Char that representes the word gived by the user
    """
    def att_ocult({value, _}, value), do: value
    def att_ocult({_, ocult}, _), do: ocult
    
    @doc """
    Transform the list of word and ocult in a unic list of tuples {x, y} when x is a latter of the original word and y is the same index in ocult.
    ## Parametres
        - Word: String, the orignal word
        - Letter: String, the letter gived by the user
        - Ocult: Ocult list
    ## Exemple
          iex> Game.turn_ocult("Marcelo")
          ["-", "-", "-", "-", "-", "-", "-"]    
    """
    def check_letter(word, letter, ocult) do
        list_letter = Enum.zip(String.codepoints(word), ocult)
        Enum.map(list_letter, fn e -> att_ocult(e, letter) end)
    end 
    
    @doc """
    Compare the orignal word with the atual ocult word, and if they are the same word, the user win's
    ## Parametres
        - Word: String. The orignal word
        - Ocult: String, the ocult word  
    ## Exemple
          iex> Game.win?("Marcelo", "-a-c-lo")
          ["-", "a", "-", "c", "-", "l", "o"] 

          iex> Game.win?("Marcelo", "Marcelo")
          :ok       
    """
    def win?(word, word), do: :ok 
    def win?(_, ocult), do: String.codepoints(ocult)

    @doc """
    Draw on the terminal the ocult word and get some letter from the user
    ## Parametres
        - Ocult: List of all "-" and letters
    ## Exemple
          iex> Game.draw(["-", "-", "-", "-", "-", "-", "-"])
          -------
          Typer a letter:

          iex> Game.draw(["-", "a", "-", "c", "-", "l", "o"])
          -a-c-lo
          Typer a letter: 
    """
    def draw(ocult, attempts) do 
        IO.puts "\nWord: #{ocult}"
        IO.puts "#{attempts} attempts left."
        String.trim(IO.gets "Type a letter: ")
    end
    
    @doc """
    Start the game
    ## Parametres
        - Word: A random word taken from the list of words
        - Ocult: The same word, but ocult "--------"
        - attempts; Int, the numbers of attempts that lefts
    ## Exemple
          iex> Game.loop("Marcelo", "-----", 2)
          # Game start

          iex> Game.loop("Marcelo", :ok, 1)
          You Win

          iex> Game.loop("Marcelo", "mar-celo", -1)
          You lose, all your attempts are end
    """
    def loop(word, :ok, _), do: IO.puts "\nCongratulations, you freed the Alchemist. \nThe word is #{word}."
    def loop(_, _, -1), do: IO.puts "\nYou lose, all your attempts are end. \nThe Alchemist remains stuck."
    def loop(word, ocult, attempts) do
        letter = draw(ocult, attempts)
        new_ocult = check_letter(word, letter, ocult)
        win = win?(word, Enum.join(new_ocult)) 
        loop(word, win, attempts - 1)
    end 
end

words = ["javascrtip", "python", "clojure", "haskell", "java", "ruby", 
         "elixir", "erlang", "ocalm", "groovy", "pascal", "swift"]

# Get a random word from the list
word = Enum.at(words, :rand.uniform(Kernel.length(words)))
ocult = Game.turn_ocult(String.codepoints(word))
# Start the game
Game.loop(word, ocult, 15)
