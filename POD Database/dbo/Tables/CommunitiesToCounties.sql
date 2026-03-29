CREATE TABLE [dbo].[CommunitiesToCounties] (
    [CommunityID] INT NOT NULL,
    [CountyID]    INT NOT NULL,
    CONSTRAINT [PK_CommunitiesToCounties] PRIMARY KEY CLUSTERED ([CommunityID] ASC, [CountyID] ASC),
    CONSTRAINT [FK_CommunitiesToCounties_Communities] FOREIGN KEY ([CommunityID]) REFERENCES [dbo].[Communities] ([CommunityID]),
    CONSTRAINT [FK_CommunitiesToCounties_Counties] FOREIGN KEY ([CountyID]) REFERENCES [dbo].[Counties] ([CountyID])
);

