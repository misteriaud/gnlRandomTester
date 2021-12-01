char *get_next_line(int fd);
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

# define SIZE 5000

void	ft_free(char **s)
{
	if (*s)
		free(*s);
	*s = 0;
}

int	main(int argc, char **argv)
{
	char strue[SIZE];
	char *smine;
	int	fd = open("./sample", O_RDONLY);
	FILE	*fp = fopen("./sample", "r");
	int	count;
	int error;

	count = 0;
	error = 0;
	while(fgets(strue, SIZE, fp) != NULL)
	{
		count++;
		smine = get_next_line(fd);
		if ((strue == NULL) != (smine == NULL) || strcmp(strue, smine))
		{
			error++;
			printf("Tour %d KO :\nfgets: %s\nget_next_line: %s\n", count,  strue, smine);
		}
		ft_free(&smine);
	}
	while (!strue && (smine = get_next_line(fd)) != NULL)
	{
		count++;
		error++;
		printf("Tour %d KO :\nfgets: NULL\nget_next_line: %s\n", count, smine);
		ft_free(&smine);
	}
	ft_free(&smine);
	if (!error)
	{
		printf("OK\n");
	}
	return (0);
}
