######code snippet for mode https://stackoverflow.com/questions/2547402/is-there-a-built-in-function-for-finding-the-mode
df = read.csv("algorithm.csv",stringsAsFactors = F)

Mode = function(x){ 
  ta = table(x)
  tam = max(ta)
  if (all(ta == tam))
    mod = "include all images"
  else
    if(is.numeric(x))
      mod = as.numeric(names(ta)[ta == tam])
  else
    mod = names(ta)[ta == tam]
  return(mod)
}
result <- c()


without_all <- dim(df)[1] - 1 
with_all <- dim(df)[1]
i <- 3
for(j in 2:dim(df)[2]){
   if(df[1,j]=="yes"){
     res <- Mode(df[i:without_all,j])
     result <- append(result,res) 
   }
  
    
    else{
      res <- Mode(df[i:(without_all-1),j])
      
      if(res=="include all images"){
        res <- Mode(df[c(3:6,8),j])
        result <- append(result,res) 
      }
      else{
        result <- append(result,res) 
      }
        
      
    }
      
    
}

result
label <- df[2,2:11]
label <- as.character(red)
table(label,result)
library(caret)
library(e1071)
label <- as.factor(label)
result <- as.factor(result)
confusionMatrix(data = label, reference = result,positive = "real")

