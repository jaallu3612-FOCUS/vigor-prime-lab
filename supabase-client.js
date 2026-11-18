// Vigor Prime Lab · Supabase client bootstrap
// Configure with your Supabase Project URL and publishable (anon) key.
// NEVER put a service_role key in this file or in a browser app.
(function () {
  const config = window.VIGOR_SUPABASE_CONFIG || {};
  const configured = Boolean(config.url && config.anonKey && window.supabase);
  window.VigorCloud = {
    configured,
    client: configured ? window.supabase.createClient(config.url, config.anonKey) : null,
    async getSession() {
      if (!this.client) return null;
      const { data, error } = await this.client.auth.getSession();
      if (error) throw error;
      return data.session;
    },
    async signUp(email, password) {
      if (!this.client) throw new Error("Vigor Cloud todavía no está configurado.");
      return this.client.auth.signUp({ email, password });
    },
    async signIn(email, password) {
      if (!this.client) throw new Error("Vigor Cloud todavía no está configurado.");
      return this.client.auth.signInWithPassword({ email, password });
    },
    async signOut() {
      if (!this.client) return;
      return this.client.auth.signOut();
    },
    async saveProfile(profile) {
      const session = await this.getSession();
      if (!session) throw new Error("Inicia sesión para guardar tu perfil.");
      return this.client.from("profiles").upsert({ id: session.user.id, ...profile }).select().single();
    },
    async addWorkout(workout) {
      const session = await this.getSession();
      if (!session) throw new Error("Inicia sesión para guardar entrenamientos.");
      return this.client.from("workouts").insert({ ...workout, user_id: session.user.id }).select().single();
    },
    async addBodyMetric(metric) {
      const session = await this.getSession();
      if (!session) throw new Error("Inicia sesión para guardar medidas.");
      return this.client.from("body_metrics").insert({ ...metric, user_id: session.user.id }).select().single();
    },
    async addMeal(meal) {
      const session = await this.getSession();
      if (!session) throw new Error("Inicia sesión para guardar comidas.");
      return this.client.from("meals").insert({ ...meal, user_id: session.user.id }).select().single();
    },
    async addSleepLog(log) {
      const session = await this.getSession();
      if (!session) throw new Error("Inicia sesión para guardar el sueño.");
      return this.client.from("sleep_logs").insert({ ...log, user_id: session.user.id }).select().single();
    }
  };
})();
