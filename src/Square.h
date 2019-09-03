#ifndef SRC_SQ_H_
#define SRC_SQR_H_

// Simply squares a given number (the DoIt function is intentionally non-static btw, as its useful for demonstrating test fixtures as this way requires instantiation)
class Square
{
public:
	int DoIt(int input);
};

#endif
