#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>

int inSize = 18;

int **createMatrix(int r, int c) //specify # of rows and columns
{
	int **matrix = (int **)calloc(r, sizeof(int *)); //create space for rows of matrix

	for (int i = 0; i < r; i++)
	{
		matrix[i] = (int *)calloc(c, sizeof(int)); //create space for each column in each row of matrix
	}
	return matrix;
}

void printMatrix(int c, int r, int **matrix)
{
	for (int i = 0; i < c; i++)
	{
		printf("------");
	}
	printf("-\n");

	for (int x = 0; x < r; x++) //iterate through rows of matrix
	{
		for (int y = 0; y < c; y++) //print each element of the selected row
		{
			printf("|%05d", matrix[x][y]);
		}
		printf("|\n");
		for (int i = 0; i < c; i++)
		{
			printf("------");
		}
		printf("-\n");
	}

	// for (int i = 0; i < c; i++)
	// {
	//   printf("------");
	// }
	// printf("-\n");
}

void fillMatrix(int c, int r, int **matrix)
{
	for (int x = 0; x < r; x++) //iterate through rows of matrix
	{
		for (int y = 0; y < c; y++) //randomly generate each element of the selected row
		{
			matrix[x][y] = (rand() % (10 - 0 + 1));
		}
	}
	printf("Matrix populated with random numbers\n");
}

int **padMatrix(int c, int r, int **matrix)
{
	int **padded = createMatrix(r + 2, c + 2);

	//fill original matrix into padded center
	for (int x = 1; x < r + 1; x++)
	{
		for (int y = 1; y < c + 1; y++)
		{
			padded[x][y] = matrix[x - 1][y - 1];
		}
	}
	printf("Matrix padded\n");
	return padded;
}

int singleConv(int c, int r, int **matrix, int **filter) //Helper function to perform a single element convolution. Input dimensions, matrix, & filter
{
	int x;
	int accum = 0;
	for (int x = 0; x < r; x++)
	{
		for (int y = 0; y < c; y++)
		{
			accum = accum + (matrix[x][y] * filter[x][y]);
		}
	}
	return accum;
}

int **matrixConv(int **k, int n, int **matrix) //input filter, input size and actual input matrix
{
	int **output = createMatrix(n - 2, n - 2); //create empty output matrix
	int **input = createMatrix(3, 3);
	for (int x = 0; x < n - 2; x++)
	{
		for (int y = 0; y < n - 2; y++)
		{
			input[0][0] = matrix[0 + x][0 + y];
			input[0][1] = matrix[0 + x][1 + y];
			input[0][2] = matrix[0 + x][2 + y];

			input[1][0] = matrix[1 + x][0 + y];
			input[1][1] = matrix[1 + x][1 + y];
			input[1][2] = matrix[1 + x][2 + y];

			input[2][0] = matrix[2 + x][0 + y];
			input[2][1] = matrix[2 + x][1 + y];
			input[2][2] = matrix[2 + x][2 + y];
			output[x][y] = singleConv(3, 3, input, k);
		}
	}

	return output;
}

int main()
{
	time_t start, end;

	srand(time(0));
	// printf("Hello World!\n");
	int **matrix = createMatrix(inSize, inSize);
	printMatrix(inSize, inSize, matrix);
	int **filter = createMatrix(3, 3);
	printMatrix(3, 3, filter);

	// fillMatrix(6, 6, matrix);
	for (int i = 0; i < inSize; i++)
	{
		for (int j = 0; j < inSize; j++)
		{
			matrix[i][j] = i * j;
		}
	}
	printMatrix(inSize, inSize, matrix);
	// fillMatrix(3, 3, filter);
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			filter[i][j] = i * j;
		}
	}
	printMatrix(3, 3, filter);

	int conv = singleConv(3, 3, matrix, filter);
	printf("Convolution: %d\n", conv);
	matrix = padMatrix(inSize, inSize, matrix);
	printMatrix(inSize + 2, inSize + 2, matrix);
	start = clock();
	matrix = matrixConv(filter, inSize + 2, matrix);
	end = clock();
	printMatrix(inSize, inSize, matrix);
	// sleep(1);
	// float timeTaken = (end. - start);
	// double tt = ((double)t) / CLOCKS_PER_SEC;
	printf("time taken: %f\n", (end - start));

	for (int i = 0; i < inSize; i++)
	{
		for (int j = 0; j < inSize; j++)
		{
			matrix[i][j] = (i + j) * (j - i);
		}
	}
	printMatrix(inSize, inSize, matrix);
	// fillMatrix(3, 3, filter);
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			filter[i][j] = (i - j) * (j + i);
		}
	}
	printMatrix(3, 3, filter);
	matrix = padMatrix(inSize, inSize, matrix);
	printMatrix(inSize + 2, inSize + 2, matrix);
	start = clock();
	matrix = matrixConv(filter, inSize + 2, matrix);
	end = clock();
	printMatrix(inSize, inSize, matrix);
	return 0;
}

// void deleteMatrix(){}
