#include "Square.h"
#include "iostream"

using namespace std;

/* the normal (non-test) program simply gets a non-negative input from the user, and then squares it.
the test program in test_main is way more interesting */
int main()
{
	int inputtedValue = 0;
	bool showErrorOnNextLoop = false;

	while(inputtedValue % 2  != 0 || inputtedValue<=0)
	{
		if(showErrorOnNextLoop)
		{
			cout << "Number must be an even number greater than zero" << endl;
		}

		cout << "Enter a number: ";
		cin >> inputtedValue;
		cout << "Inputed number: " << inputtedValue << endl;
		showErrorOnNextLoop = true;
	}

	Square* squarer = new Square();
	unsigned int sqResult = squarer->DoIt(inputtedValue);

	delete squarer;

	cout << "Squared number: " << sqResult << endl;
	return 0;
}
