char *get_next_line(int fd);
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

# define SIZE 5000

void	ft_free(char **s)
{
	if (*s)
		free(*s);
	*s = 0;
}

int	main()
{
	char strue1[SIZE];
	char strue2[SIZE];
	char *smine1;
	char *smine2;
	int	fd1;
	int	fd2;
	FILE	*fp1;
	FILE	*fp2;
	int	count;
	int error;

	fd1 = open("./sample_bonus1", O_RDONLY);
	fd2 = open("./sample_bonus2", O_RDONLY);

	fp1 = fopen("./sample_bonus1", "r");
	fp2 = fopen("./sample_bonus2", "r");
	
	count = 0;
	error = 0;
	while(fgets(strue1, SIZE, fp1) != NULL)
	{
		count++;
		fgets(strue2, SIZE, fp2);
		smine1 = get_next_line(fd1);
		smine2 = get_next_line(fd2);
		if ((strue1 == NULL) != (smine1 == NULL) || strcmp(strue1, smine1))
		{
			error++;
			printf("(0)Tour %d KO (sample1):\nfgets: %s\nget_next_line: %s\n", count,  strue1, smine1);
		}
		if ((strue2 == NULL) != (smine2 == NULL) || strcmp(strue2, smine2))
		{
			error++;
			printf("(1)Tour %d KO (sample2):\nfgets: %s\nget_next_line: %s\n", count,  strue2, smine2);
		}
		ft_free(&smine1);
		ft_free(&smine2);
	}
	ft_free(&smine1);
	ft_free(&smine2);
	if (!error)
	{
		printf("OK\n");
	}
	close(fd1);
	close(fd2);
	fclose(fp1);
	fclose(fp2);
	return (0);
}
