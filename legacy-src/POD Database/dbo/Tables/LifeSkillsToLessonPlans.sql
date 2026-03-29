CREATE TABLE [dbo].[LifeSkillsToLessonPlans] (
    [LifeSkillTypeID] INT NOT NULL,
    [LessonPlanID]    INT NOT NULL,
    CONSTRAINT [PK_LifeSkillsToLessonPlans] PRIMARY KEY CLUSTERED ([LifeSkillTypeID] ASC, [LessonPlanID] ASC),
    CONSTRAINT [FK_LifeSkillsToLessonPlans_LessonPlans] FOREIGN KEY ([LessonPlanID]) REFERENCES [dbo].[LessonPlans] ([LessonPlanID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_LifeSkillsToLessonPlans_LifeSkillTypes] FOREIGN KEY ([LifeSkillTypeID]) REFERENCES [dbo].[LifeSkillTypes] ([LifeSkillTypeID]) ON DELETE CASCADE ON UPDATE CASCADE
);

