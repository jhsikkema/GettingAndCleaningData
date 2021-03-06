# Project from Getting and Cleaning Data (Coursera)
## Introduction

This repository contains a script that cleans up data from  <a href=“http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones”> the machine learning database concerning wearables</a>.


## Files
<ul>
<li> README.md: This file </li>
<li> run_analysis.R: Script to cleanup the dataset </li>
<li> CodeBook.pdf: A file describing the variables in the resulting dataset </li>
</ul> 

## Functionality
The script filters out irrelevant columns and calculates the means of the relevant columns per test subject per activity. Also it process the data so the activities are labelled in an easier to read way. Finally it reverse the division in train and test data and glues the two datasets together.

The following steps are taken:
<ul>
<li> The datasets are downloaded and unzipped. </li>
<li> The interesting columns are selected </li>
<li> A translation table is build for the activities </li>
<li> For the train and testset the following steps are taken: 
<ul>
<li> The data is read from file. </li>
<li> The column names are cleaned up </li>
<li> The activities are merged in the dataset in a readable format </li>
<li> The test subject’s id is merged in the dataset </li>
</ul>
</li>
<li> The train and test sets are merged </li>
<li> The means for all columns are calculated per subject per activity </li>
<li> The results are written to file </li>
</ul>

## Invoking the script.
From R or R-studio the script needs to be in the working directory (or the working directory needs to be updated to the directory of the script). Then it can be invoked and any necessary data is downloaded automagically.
