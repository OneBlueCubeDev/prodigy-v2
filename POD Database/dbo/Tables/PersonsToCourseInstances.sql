CREATE TABLE [dbo].[PersonsToCourseInstances] (
    [PersonID]         INT NOT NULL,
    [CourseInstanceID] INT NOT NULL,
    CONSTRAINT [PK_PersonsToCourseInstances] PRIMARY KEY CLUSTERED ([PersonID] ASC, [CourseInstanceID] ASC),
    CONSTRAINT [FK_PersonsToCourseInstances_CourseInstances] FOREIGN KEY ([CourseInstanceID]) REFERENCES [dbo].[CourseInstances] ([CourseInstanceID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_PersonsToCourseInstances_Persons] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons] ([PersonID]) ON DELETE CASCADE ON UPDATE CASCADE
);

