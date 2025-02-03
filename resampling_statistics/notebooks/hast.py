
import numpy as np

## Bootstrapping functions
# A function to generate one bootstrap replicate with given 1-d sample and statistic
def bs_replicate_1d(data, func):
    '''Generate one bootstrap sample with a given 1-d sample and a function to calculate the statistic
    
    Parameters
    ----------
    data : int/double array
        A given 1-d sample
    func : function name
        A function to calculate the test statistic of interest

    Returns
    -------
    bs_sample
        A statistic calculated from the generated bootstrap sample

    '''

    bs_sample = np.random.choice(data, size = len(data))
    return func(bs_sample)





# Write a function to draw bootstrap replicates with 3 inputs: sample data, function to calculate statistic, number of replicates
def draw_bs_reps(data, func, size = 1):
    '''Generate Bootstrap replicates with a given 1-d sample, a function to calculate statistic of interest, and the number of replicates to generate

    Parameters
    ----------
    data : int/double array
        A given 1-d sample
    func : function name
        The function to calculate the test statistic of interest
    size : int
        The number of replicates to generate

    Returns
    -------
    bs_replicates
        An array of generated Bootstrap replicates

    '''
    
    # Initialize array of replciates: bs_replicates
    bs_replicates = np.empty(size)
    
    # Generate replicates
    for i in range(size):
        bs_replicates[i] = bs_replicate_1d(data, func)
        
    return(bs_replicates)





## Permutation test functions

# A function to get permutation sample
def permutation_sample(data1, data2):
    '''Generate a permutation sample from two input 1-d arrays

    Parameters
    ----------
    data1 : int/double array
        The first given 1-d array
    data2 : int/double array
        The second given 1-d array

    Returns
    -------
    perm_out_1 : int/double array
        A permuted output array with the same size as data1
    perm_out_2 : int/double array
        A permuted output array with the same size as data2

    '''
    
    # Concatenate the two input datasets into one array
    data = np.concatenate((data1, data2))
    
    # Permute the data
    permute_data = np.random.permutation(data)
    
    # Split the permuted array into two
    perm_out_1 = permute_data[:len(data1)]
    perm_out_2 = permute_data[len(data1):]
    
    # Return the two permuted arrays
    return(perm_out_1, perm_out_2)



# A function to generate permutation statistic replicates
def draw_permutation_reps(data1, data2, func, size = 1):
    '''Generate permutation statistic replicates of given size
    
    Parameters
    ----------
    data1 : int/double array
        The first given 1-d array
    data2 : int/double array
        The second given 1-d array
    func : function name
        The function to calculate the statistic of interest
    size : int
        The number of replicates to generate

    Returns
    -------
    perm_reps
        An array of generated Permutation test statistics


    '''
    
    # Initiate an empty permutation array
    perm_reps = np.empty(size)
    
    for i in range(size):
        perm_sample_1, perm_sample_2 = permutation_sample(data1, data2)
        perm_reps[i] = func(perm_sample_1, perm_sample_2)
        
    return(perm_reps)


# A function to compute difference between means of two arrays
def mean_diff(arr1, arr2):
    '''Compute difference between means of two input arrays
    
    Parameters
    ----------
    arr1 : int/double array
        The first given 1-d array
    arr2 : int/double array
        The second given 1-d array

    Returns
    -------
    diff
        A value of difference between means of two input arrays 


    '''
    
    diff = np.mean(arr2) - np.mean(arr1)
    return(diff)
