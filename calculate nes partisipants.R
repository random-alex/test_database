
# prereq ------------------------------------------------------------------
require(plotly)

# functions ---------------------------------------------------------------
#formula for power calcultion http://statistica.ru/local-portals/medicine/planirovanie-meditsinskikh-issledovaniy/
my_power_cal <- function(p0,pk,a = alpha,b = bt,delta = 0.1){
  (a + b)^2*(p0*(1 - p0) + pk*(1 - pk))/(delta)^2
}



# calc point power --------------------------------------------------------

alpha <- 0.025
power <- 0.8
bt <- 1 - power
delta <- 0.1
#I don't have any information about distribution of sucsess in control neither test group, so I will think , 
#that they will be smth like this:
#In real world there are almost preveous study, from were we could take needed values
p0 <- 0.65
pk <- 0.7

n <- my_power_cal(p0,pk)
  

# simmulate ---------------------------------------------------------------

p_min <- 0.1
p_max <- 0.8
step <- 0.05

p <- seq(p_min,p_max,by = step)

n_matrix <- matrix(1,NROW(p),NROW(p),
                   dimnames = list(as.character(p),as.character(p)))
for (i in c(1:NROW(p))){
  n_matrix[,i] <- my_power_cal(p[i],p)
}

n_df <- cbind(pk = rownames(n_matrix),n_matrix) %>% 
  as.tibble() %>% 
  gather(p0,num,-1) %>% 
  mutate(num = as.numeric(str_replace(num,',','.')))

#plot multiple 
n_df %>% 
  ggplot(aes(p0,num,col = pk,group = pk)) +
  geom_line() +
  geom_point() +
  theme_bw()





