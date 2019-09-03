#include "Square.h"
#include "SquareRoot.h"
#include "gtest/gtest.h"

/* This defines a test fixture for us to use. It is basically a class that creates an instance of the Square class
//prior to the current test, and then deletes it after completion.*/
class SquareTestFixture : public ::testing::Test //fixtures always subclass from this
{
protected:
	Square* sq;

    void SetUp() override;
    void TearDown() override;
};

void SquareTestFixture::SetUp()
{
	sq = new Square();
}

void SquareTestFixture::TearDown()
{
	delete sq;
	sq = NULL;
}

/*TEST_F means you are using a test fixture (i.e. an instance of the SquareTestFixture class defined above)
  This instructs the framework to instantiate SquareTestFixture, run the SetUp() member function, then run the test,
  run the TearDown() member function, then destroy the instance of SquareTestFixture */
TEST_F(SquareTestFixture, PositiveNos)
{
	ASSERT_EQ(36, sq->DoIt(6));
	ASSERT_EQ(64, sq->DoIt(8));
	ASSERT_EQ(81, sq->DoIt(9));
	ASSERT_EQ(100, sq->DoIt(10));
}

//This uses a fresh instance of the SquareTestFixture class - not the same object as above
TEST_F(SquareTestFixture, NegativeNumbers)
{
	ASSERT_EQ(49, sq->DoIt(-7));
	ASSERT_EQ(64, sq->DoIt(-8));
}

//Here we are not using a fixture, we instantiate the SquareRoot object ourselves inside the test
TEST(SqRootTest, PositiveNumbers)
{
	SquareRoot sqRoot;
	ASSERT_EQ(7, sqRoot.DoIt(49));
	EXPECT_EQ(9, sqRoot.DoIt(81)); //expect means that this test continues and attempts the next statement even if it fails
	ASSERT_EQ(6, sqRoot.DoIt(36));
}

//The actual test program entry point
int main(int argc, char **argv)
{
	testing::InitGoogleTest(&argc, argv); //always needed
	return RUN_ALL_TESTS(); //the typical way that tests are run
}
