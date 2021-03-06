% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate_multicluster.R
\name{simulate_multicluster}
\alias{simulate_multicluster}
\title{Simulate multicluster counts with time dependent association from a Dirichlet-Multinomial distribution}
\usage{
simulate_multicluster(
  counts = NULL,
  nr_diff = 2,
  nr_samples = NULL,
  alphas = NULL,
  theta = NULL,
  sizes = NULL,
  covariate = NULL,
  slope = NULL,
  group = NULL,
  group_slope = NULL,
  diff_cluster = FALSE,
  enforce_sum_alpha = FALSE,
  return_summarized_experiment = FALSE
)
}
\arguments{
\item{counts}{the reference counts data set, either a matrix with rows as cluster and colums as samples or
a \code{\link[SummarizedExperiment]{SummarizedExperiment}} object as generated from \code{\link{calcCounts}}.}

\item{nr_diff}{number of clusters where an association should be introduced. Has to be an even number.}

\item{nr_samples}{number of samples in output data. If NULL will set to same as input data.}

\item{alphas}{alpha parameter of Dirichlet-Multinomial distribution. If 'NULL' will be estimated from 'counts'.}

\item{theta}{correlation parameter. If 'NULL' will be estimated from 'counts'.}

\item{sizes}{total sizes for each sample}

\item{covariate}{covariates, one for each sample. Default Null means random draws from an exponential distribution with rate = 1.}

\item{slope}{negative double. Coefficients corresponding to the covariate for the DA clusters. One for each pair of DA clusters. 
To ensure correctness of the final distribution use only negative values. Alternatively can be a list of length 'nr_diff'/2, 
where each elements indicates the proportion of the cluster size at the maximum covariate relative to the mean. E.g. 0.1 means
that the cluster proportion at the maximum covariate is 0.1 times smaller than the mean.}

\item{group}{either Null (no group effect), double between 0 and 1 (proportion of samples with group effect), 
integer (total number of samples with group effect), vector of 0 and 1 (indicating which samples have a group effect)
or TRUE (effect with even group size).}

\item{group_slope}{regression coefficient of second covariate 'group'. If Null will choose a value automatically.
Alternatively can be a list of length 'nr_diff'/2, where each elements indicates the proportion of the cluster 
size at the maximum covariate relative to the mean. E.g. 0.1 means that the cluster proportion at the maximum 
covariate is 0.1 times smaller than the mean.}

\item{diff_cluster}{Logical. Should the clusters be choosen random (TRUE) or according to a minimal distance of
of mean cluster sizes (FALSE). Alternatively a list of length 'nr_diff' with each element
a vector of length 2 indicating the paired clusters can be given. Default is FALSE.}

\item{enforce_sum_alpha}{Logical. Should the total sum of alphas be kept constant to ensure randomness of
non association clusters. The drawback is that one of the two paired clusters with an association
will not follow a GLMM (binomial link function) exactly any more. Default is TRUE.}

\item{return_summarized_experiment}{logical. Should the counts returned as a \code{\link[SummarizedExperiment]{SummarizedExperiment}}
object. Default is FALSE.}
}
\value{
returns a list with elements counts (either matrix or SummarizedExperiment object, depending on input),
  row_data (data per cluster: regression coefficients used), col_data (data per sample: covariates), 
  alphas (matrix of alpha parameters used), theta (theta parameter), 
  var_counts (covariance matrix of a DM distribution with the given alphas and sizes).
}
\description{
Simulate multicluster counts with time dependent association from a Dirichlet-Multinomial distribution
}
\examples{
# without data reference:
alphas <- runif(20,10,100)
sizes <- runif(10,1e4,1e5)
output <- simulate_multicluster(alphas=alphas,sizes=sizes)
# counts:
counts <- output$counts

# with data reference:
# first simulate reference data set (normally this would be a real data set):
data <- t(dirmult::simPop(n=runif(10,1e4,1e5),theta=0.001)$data)
# then generate new data set based on original one but if DA clusters
output <- simulate_multicluster(data)

# specify number of differential clusters (has to be an even number):
output <- simulate_multicluster(alphas=alphas,sizes=sizes,nr_diff = 4)

# specify which clusters should be differential:
output <- simulate_multicluster(alphas=alphas,
                                sizes=sizes,
                                nr_diff = 4, 
                                diff_cluster = list(c(2,9),c(6,7)))

# with second covariate (group):
output <- simulate_multicluster(alphas=alphas,sizes=sizes, group = TRUE)

# with second covariate (group), specify group proportion:
output <- simulate_multicluster(alphas=alphas,sizes=sizes, group = 0.5)

# with second covariate (group), specify id of group memberships for one group:
output <- simulate_multicluster(alphas=alphas,sizes=sizes, group = 3:7)
}
