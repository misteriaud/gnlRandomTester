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
	char	buff[3][SIZE];
	char	*strue[3];
	char	*smine[3];
	int		fd[3];
	FILE	*fp[3];
	int		count;
	int		error;



	fd[0] = open("./sample_bonus0", O_RDONLY);
	fd[1] = open("./sample_bonus1", O_RDONLY);
	fd[2] = open("./sample_bonus2", O_RDONLY);

	fp[0] = fopen("./sample_bonus0", "r");
	fp[1] = fopen("./sample_bonus1", "r");
	fp[2] = fopen("./sample_bonus2", "r");
	
	count = 0;
	error = 0;
	while((strue[0] = fgets(buff[0], SIZE, fp[0])) != NULL)
	{
		count++;
		strue[1] = fgets(buff[1], SIZE, fp[1]);
		strue[2] = fgets(buff[2], SIZE, fp[2]);
		smine[0] = get_next_line(fd[0]);
		smine[1] = get_next_line(fd[1]);
		smine[2] = get_next_line(fd[2]);
		for (int j = 0; j < 3; j++)
		{
			if (strue[j] && smine[j] && strcmp(strue[j], smine[j]))
			{
				error++;
				printf("Tour %d KO (sample%d):\nfgets: %s\nget_next_line: %s\n", count, j, strue[j], smine[j]);
			}
			else if ((strue[j] == 0) != (smine[j] == 0))
			{
				error++;
				printf("Tour %d KO (sample%d):\nfgets: %s\nget_next_line: %s\n", count, j, strue[j], smine[j]);
			}
			ft_free(&smine[j]);
		}
	}
	ft_free(&smine[0]);
	ft_free(&smine[1]);
	ft_free(&smine[2]);
	if (!error)
	{
		printf("OK\n");
	}
	close(fd[0]);
	close(fd[1]);
	close(fd[2]);
	fclose(fp[0]);
	fclose(fp[1]);
	fclose(fp[2]);
	return (0);
}
