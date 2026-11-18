# Vigor Prime Lab · Cloud database setup

The cloud data layer is prepared for Supabase.

## 1. Create a Supabase project
Create a project at https://supabase.com/dashboard. Keep the database password private.

## 2. Create the tables securely
Open SQL Editor in the Supabase dashboard, paste the contents of `supabase/schema.sql`, and run it. Row Level Security is enabled; authenticated users can only access rows with their own user ID.

## 3. Configure the browser client
In Project Settings → API, copy the Project URL and the publishable/anon key. Never use the `service_role` key in a browser app.

Add this configuration before loading `supabase-client.js`:
```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script>
  window.VIGOR_SUPABASE_CONFIG = {
    url: "YOUR_SUPABASE_PROJECT_URL",
    anonKey: "YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY"
  };
</script>
<script src="supabase-client.js"></script>
```

## Current status
The schema and client helper are starter infrastructure. They do not yet migrate the app's existing local data or automatically connect every screen. Do not describe cloud sync as active until a Supabase project is configured, authentication is enabled, and each screen is wired and tested.
