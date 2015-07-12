# Keypad-Puzzle
Made in Verilog using an Altera DE2 FPGA. Code compiled using Quartus.

Main file: controller.v <br>
Video: https://www.youtube.com/watch?v=C1hH2x2ouWI

<img src="http://1.bp.blogspot.com/_U89HXudgNZE/S5uuNncw2BI/AAAAAAAAAgI/ApeJFkhn10s/s1600/Image22.png" alt="Nancy Drew" />

Object of the puzzle is to guess the 9-number access code! There is an FSM with a couple of states:
<html>
<body>

<h2>FSM States</h2>

<ol>
  <li>Entering the access code</li>
  <li>Correct code entered</li>
  <li>Change the passcode (need to enter another special code to enter this state).</li>
</ol>  

</body>
</html>

The trick to the game is that each correct key in the sequence entered lights up (the code is made up of all 9 different keys). Each time you'll need to guess the next one, and if your guess is right the key you pressed will light up and you'll have the remaining non-lit keys to choose from again, otherwise all the lit up keys will become OFF and you'll need to start over. So you need to use your memory and deduce the right sequence!

The keypad interface was built from scratch using LED tactile switches, and soldering a keypad matrix.

<img src="Keypad Hardware.jpg" height="317" width="423"/>
