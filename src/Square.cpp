#include "Square.h"

// Simply squares a given number. this function could be static really, but is useful for demonstrating test fixtures as this way requires instantiation
int Square::DoIt(int input)
{
	return input * input;
}
