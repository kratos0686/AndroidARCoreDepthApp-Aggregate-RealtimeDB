# IICRC AI Assistant - Quick Start Guide

## Getting Started

The **IICRC Certified Master Water Restorer AI Assistant** is integrated into your AR Room Scanner app to provide expert restoration guidance on-site.

## Setup

1. **Configure API Key**
   - Obtain a Gemini API key from: https://makersuite.google.com/app/apikey
   - Open `.env` file in the project root
   - Replace `your_gemini_api_key_here` with your actual key:
     ```
     GEMINI_API_KEY=AIza...your_key_here
     ```
   - Restart the app

2. **Access the Assistant**
   - Open the app
   - Tap the "IICRC AI" icon in the bottom navigation bar
   - You'll see 7 categories of expertise

## Using the Assistant

### 1. Water Mitigation
**When to use**: Any water damage scenario

**How to use**:
1. Tap "Water Mitigation"
2. Describe the water damage in detail:
   - Source of water (pipe burst, flood, rain, etc.)
   - Areas affected (living room, kitchen, basement)
   - Materials impacted (carpet, drywall, hardwood)
   - Time since water intrusion
3. Tap "Assess Damage"
4. Review the classification:
   - **Water Class** (1-4): Extent of damage
   - **Water Category** (1-3): Contamination level
   - **Equipment needed**: Dehumidifiers, air movers, etc.
   - **Estimated drying time**
   - **Required PPE level**

**Example**:
```
"Burst pipe in kitchen sink, water flowed into adjacent dining room. 
Laminate flooring in kitchen, carpet in dining room. Discovered 2 hours ago."
```

### 2. Mold Remediation (S520)
**When to use**: Visible mold growth or suspected contamination

**How to use**:
1. Tap "Mold Remediation"
2. Describe the mold situation:
   - Location and extent
   - Visible signs (color, texture, smell)
   - Moisture source if known
3. Optionally attach a photo
4. Review S520-compliant guidance:
   - **Condition Level** (1-4)
   - **Containment requirements**
   - **Remediation protocol steps**
   - **PPE specifications**
   - **Post-remediation verification**

### 3. Fire Damage
**When to use**: Smoke or fire damage assessment

**How to use**:
1. Tap "Fire Damage"
2. Describe the fire damage scenario
3. Get guidance on:
   - Smoke type identification
   - Structural safety
   - Salvageable vs. non-salvageable items
   - Cleaning methods
   - Odor control

### 4. PPE Recommendations
**When to use**: Before entering any work site

**How to use**:
1. Tap "PPE Recommendations"
2. Describe the work scenario
3. List known hazards (optional):
   - Black water
   - Mold
   - Chemical exposure
   - Confined space
4. Review recommended equipment:
   - **PPE Level** (1-4)
   - Specific gear for head, eyes, respiratory, hands, body, feet
   - Decontamination procedures

**Safety First**: Always follow PPE recommendations before starting work!

### 5. Psychrometric Analysis
**When to use**: Monitoring drying progress

**How to use**:
1. Tap "Psychrometric Analysis"
2. Input current readings:
   - Temperature (°F)
   - Relative Humidity (%)
   - Grains Per Pound (GPP) - if available
3. Review analysis:
   - **Dew Point** calculation
   - **Drying potential** (good/fair/poor)
   - **Target conditions** to achieve
   - **Equipment recommendations**
   - **Estimated drying time**

**Tip**: Take readings daily to track drying progress. Compare with outdoor conditions.

### 6. Damage Assessment
**When to use**: Documenting damage with photos

**How to use**:
1. Tap "Damage Assessment"
2. Take or select a photo
3. Optionally add context (room name, notes)
4. AI analyzes the image for:
   - **Materials identified**
   - **Damage type** (water, mold, fire, structural)
   - **Severity level**
   - **Affected areas** with size estimates
   - **Moisture indicators**
   - **Safety hazards**
   - **Immediate actions needed**

**Best Practice**: Take multiple photos from different angles for comprehensive assessment.

### 7. Ask a Question
**When to use**: Any restoration-related question

**How to use**:
1. Tap "Ask a Question"
2. Type your question in natural language
3. Get expert IICRC guidance in real-time
4. Continue the conversation for follow-up questions

**Example Questions**:
- "What's the difference between Class 2 and Class 3 water damage?"
- "How many air movers do I need for a 400 sq ft room?"
- "When should I call for professional mold testing?"
- "What cleaning method for synthetic smoke on painted drywall?"
- "How do I calculate ACH (air changes per hour) for containment?"

## Tips for Best Results

### Be Specific
✅ Good: "Category 2 water from washing machine overflow, affected 200 sq ft of carpet and pad, discovered 6 hours ago"

❌ Too vague: "There's water damage"

### Include Context
- Room dimensions when relevant
- Time elapsed since damage occurred
- Previous moisture issues if any
- Building type (residential, commercial, multi-story)

### Take Clear Photos
- Good lighting
- Multiple angles
- Close-ups of damage
- Wide shots showing extent

### Follow-Up
- Ask clarifying questions in the Q&A
- Request equipment specifications if needed
- Confirm understanding of procedures

## Understanding AI Responses

### Water Classes
- **Class 1**: Minimal, localized
- **Class 2**: Significant, room-wide
- **Class 3**: Maximum absorption, overhead source
- **Class 4**: Specialty materials (hardwood, concrete)

### Water Categories
- **Category 1**: Clean water (sanitary source)
- **Category 2**: Grey water (contaminated)
- **Category 3**: Black water (grossly contaminated)

### Mold Conditions
- **Condition 1**: Normal ecology
- **Condition 2**: <10 sq ft
- **Condition 3**: 10-100 sq ft
- **Condition 4**: >100 sq ft

### PPE Levels
- **Level 1**: Basic (routine cleaning)
- **Level 2**: Enhanced (mold, grey water)
- **Level 3**: Full protection (black water, extensive mold)
- **Level 4**: Hazmat (chemical hazards)

## Important Notes

### The AI Assistant CAN:
✅ Provide IICRC-standard guidance
✅ Classify damage according to industry standards
✅ Recommend equipment and procedures
✅ Identify safety hazards
✅ Calculate psychrometric conditions
✅ Analyze photos for damage assessment

### The AI Assistant CANNOT:
❌ Replace on-site professional judgment
❌ Approve insurance claims
❌ Detect hidden damage not visible in photos
❌ Replace actual measurement tools
❌ Make final decisions about structural safety
❌ Substitute for licensed contractors

### Always Remember:
⚠️ Verify recommendations with your supervisor
⚠️ Follow company protocols
⚠️ Use proper measurement equipment
⚠️ Document everything independently
⚠️ Prioritize safety above all else

## Troubleshooting

### "API key not configured"
- Check `.env` file has valid Gemini API key
- Restart the app after updating `.env`

### "Failed to initialize"
- Ensure internet connection is active
- Verify API key is correct and not expired
- Check if Gemini API has usage limits

### Slow responses
- Gemini API responses depend on network speed
- Typical response time: 2-5 seconds
- For images: 5-10 seconds

### Unexpected results
- Provide more context in your description
- Use the "Ask a Question" feature to clarify
- Rephrase your question if needed

## Support

For technical issues:
1. Check your API key configuration
2. Verify internet connectivity
3. Review error messages
4. Contact your IT support

For restoration questions:
1. Use the "Ask a Question" feature
2. Consult with IICRC-certified supervisors
3. Reference IICRC standards documentation

## Additional Resources

### IICRC Standards
- WRT: Water Damage Restoration Technician
- S500: Water Damage Restoration Standard
- S520: Mold Remediation Standard
- FSRT: Fire and Smoke Restoration Technician
- AMRT: Applied Microbial Remediation Technician

### Documentation
- `IICRC_ASSISTANT.md`: Detailed technical documentation
- `REQUIREMENTS.md`: Complete feature specifications
- `README.md`: Project overview

---

**Version**: 1.0.0  
**Last Updated**: 2025-12-05  
**Support**: See IICRC_ASSISTANT.md for detailed information
